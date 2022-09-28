extends Node2D

# cards
const BATTLECARD = preload("res://src/battle/card_related/BattleCard.tscn")

const ENEMY_TYPES = EnemyEnum.ENEMY_TYPES
const EFFECT_TYPES = EffectEnum.EFFECT_TYPES
const CARD_STATES = CardStateEnum.CARD_STATES

var deck = []
var hand = []
var discard = []
var slots = []
var played = []

var words_left = 1

func _ready():
	randomize()
	var last_slot = $LetterSlots.get_child($LetterSlots.get_child_count() - 1)
	# center enter button
	$SubmitWord.rect_position = last_slot.rect_position + Vector2(last_slot.rect_size.x, 
	last_slot.rect_size.y * last_slot.rect_scale.y/2 - $SubmitWord.rect_size.y/2)
	
	$Enemy.setup_enemy(ENEMY_TYPES.BASIC, 100, 10, {EFFECT_TYPES.WEAKNESS: 50, EFFECT_TYPES.BURN: 30})
	
	# fill deck with cards
	for card in Saver.deck:
		var new_card = BATTLECARD.instance()
		# four lines below are for setting up test cards
		var card_data = CardData.new()
		card_data.load_default(card.name)
		new_card.set_card_data(card_data)
		new_card.set_locations($Deck, $Discard)
		new_card.connect("slot_changed", self, "_update_slot_and_hand")
		$Cards.add_child(new_card)
		deck.append(new_card)
	
	for card in deck:
		hand.append(card)
	deck.clear()
	update_cards()

func update_cards(): # moves cards into right place
	for i in range(deck.size()):
		deck[i].update_card(deck, hand, discard, slots, played, 0, i)
	
	for i in range(hand.size()):
		hand[i].update_card(deck, hand, discard, slots, played, 1, i)
		
	for i in range(discard.size()):
		discard[i].update_card(deck, hand, discard, slots, played, 2, i)
	
	for i in range(slots.size()):
		slots[i].update_card(deck, hand, discard, slots, played, 3, i)

	for i in range(played.size()):
		played[i].update_card(deck, hand, discard, slots, played, 4, i)

func end_turn():
	$Enemy.attack($Player) # do this when player ends turn

func _update_slot_and_hand(to_slots, to_hand):
	# move replaced card to hand
	if to_hand != null:
		hand.erase(to_hand)
		hand.append(to_hand)
		slots.erase(to_hand)
	
	# move placed card to slots
	if to_slots != null:
		slots.erase(to_slots)
		slots.append(to_slots)
		hand.erase(to_slots)
	
	for i in range(0, slots.size()): # resort slots, insertion sort
		var smallest = slots[i].in_slot
		var index = i
		for j in range(i + 1, slots.size()):
			if slots[j].in_slot < smallest:
				smallest = slots[j].in_slot
				index = j
		var temp = slots[i]
		slots[i] = slots[index]
		slots[index] = temp
	
	for card in hand:	# reoreint cards
		$Cards.move_child(card, 0)
		
	update_cards()

func _validity(string: String):
	var dic = File.new()
	dic.open("res://assets/temp_peter/dictionary.txt", File.READ)
	var lines = dic.get_as_text().split('\n')
	dic.close()
	if string.to_upper() in lines:
		return true
	return false		
	
func _word_resolution(cards,text):
	var dmgs=0
	var draws=0
	var words=0
	var modifiers=1
	var word_data={}
	word_data.persistentEffects=[]
	for i in range (len(cards)):
		var card = cards[i].card_data
		var dmg=card.damage
		var draw=card.draw_count
		var word=card.word_count
		var modifier = 0
		if card.effects == 'Burn':
			word_data["persistentEffects"].append(EFFECT_TYPES.BURN)
		if card.effects == 'Freeze':
			word_data["persistentEffects"].append(EFFECT_TYPES.FREEZE)
		if card.effects == 'Gold':
			Saver.gold += 1 # arbitrary gold increase
		if card.effects == 'Heal':
			$Player.damage(-5) # arbitrary heal amount
		if card.effects == 'Paralyze':
			word_data["persistentEffects"].append(EFFECT_TYPES.PARALYZE)
		if card.effects == 'Weaken':
			word_data["persistentEffects"].append(EFFECT_TYPES.WEAKEN)
		"""if card.effects == 'End Turn':
			#apply end turn"""
		if card.effects == '+1 Word if not used in the first slot' and i!=0:
			word += 1
		if card.effects == '+200% Damage, -50% Damage to self':
			modifier += 2
		if card.effects == '+2 Damage if next to another L':
			dmg += 2 * ((i!=0 and cards[i-1].card_data.name == 'L')+(i!=len(cards)-1 and cards[i+1].card_data.name == 'L'))
		if card.effects == '+50% Damage':
			modifier += 0.5
		if card.effects == '+2 Damage if O is the only vowel' and _overlap(text, 'O') and not _overlap(text, 'AEIU'): 
			modifier += 0.5
		"""if card.effects == 'Draw this Q and another card next turn':
			modifier += 0.5"""
		if card.effects == 'End Turn, +100% Damage':
			modifier += 1
			#apply end turn
		if card.effects == '+100% Damage if not at the end of the word' and i!=len(cards)-1:
			modifier += 1
		dmgs+=dmg
		words+=word
		draws+=draw
		modifiers+=modifier
	word_data.dmg=dmgs*modifiers
	word_data.draw=draws
	word_data.word=words
	return word_data

func _is_member(string, key):
	for i in range(0, string.length()):
		if key == string[i]:
			return true
	return false
func _overlap(string1 , string2):
	for i in range(0, string1.length()):
		var letter = string1[i]
		if _is_member(string2, letter ):
			return true
	return false

func _submit_word():
	var word = ""
	for card in slots:
		word += card.card_data.name
		
	var valid = _validity(word)
	if true: # idk what happened to dictionary.txt
		var word_data = _word_resolution(slots,word)
		$Player.attack($Enemy, word_data["dmg"], word_data["persistentEffects"])
		print("submitted word: " + word)
		print(word_data)
		print("submitted word is " + ("valid" if valid else "not valid"))
	
func _on_player_damaged(value):
	print("player hp now ", value)
	if value <= 0:
		print("player died!") # do smthn


func _on_enemy_damaged(value):
	print("enemy hp now ", value)
	if value <= 0:
		print("enemy died!") # do smthn
