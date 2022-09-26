extends Node2D

# cards
const CARDSIZE = Vector2(125,175)
const BATTLECARD = preload("res://src/battle/card_related/BattleCard.tscn")
const DECK = preload("res://src/cards/Deck.gd")

const ENEMY_TYPES = EnemyEnum.ENEMY_TYPES
const EFFECT_TYPES = EffectEnum.EFFECT_TYPES

var card_selected = []
onready var deck_size = DECK.DECKLIST.size()

#Getting position to put in hand after draw
onready var center_card_oval = get_viewport().size * Vector2(0.5, 1.33)
onready var hor_rad = get_viewport().size.x * 0.55
onready var ver_rad = get_viewport().size.y * 0.4
var angle = 0
var card_numb = 0
var number_cards_hand = 0
var card_spread = 0.15
var oval_angle_vector = Vector2()

func _ready():
		randomize()
		var last_slot = $LetterSlots.get_child($LetterSlots.get_child_count() - 1)
		# center enter button
		$SubmitWord.rect_position = last_slot.rect_position + Vector2(last_slot.rect_size.x, 
		last_slot.rect_size.y * last_slot.rect_scale.y/2 - $SubmitWord.rect_size.y/2)
		
		$Enemy.setup_enemy(ENEMY_TYPES.BASIC, 100, 10, {EFFECT_TYPES.WEAKNESS: 50, EFFECT_TYPES.BURN: 30})
		
func draw_card():
	# set up an angle of a card
	angle = PI/2 + card_spread*(float(number_cards_hand)/2 - number_cards_hand)
	# initialize a a drawn card
	var new_card = BATTLECARD.instance()
	# four lines below are for setting up test cards
	var card_data = CardData.new()
	card_selected = DECK.DECKLIST[randi() % deck_size]
	card_data.load_default(card_selected)
	new_card.set_card_data(card_data)
	
	oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
	
	new_card.rect_position = $Deck.position - CARDSIZE/2 # set starting position
	
	new_card.set_default_display(
		center_card_oval + oval_angle_vector - CARDSIZE, # default pos
		(90 - rad2deg(angle))/4, # default rot
		Vector2(1, 1) # default scale
	)
	new_card.connect("on_slot_filled", self, "_on_hand_count_change")
	new_card.connect("redraw_hand", self, "_redraw_hand")
	$Cards.add_child(new_card)
	new_card.default_display() # does card animation from deck to hand
	new_card.focus_detect = true # hovering enlarges card
	
	organize_cards() # reorients rest of cards in hand
	
	DECK.DECKLIST.erase(card_selected)
	deck_size -= 1
	number_cards_hand += 1
	return deck_size

func organize_cards():
	card_numb = 0
	for card in $Cards.get_children(): # reorganise hand
		# ignore card if in slot
		if card.in_slot == -1:
			angle = PI/2 + card_spread*(float(number_cards_hand)/2 - card_numb)
			oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
			card.set_default_display(
				center_card_oval + oval_angle_vector - CARDSIZE, # default pos
				(90 - rad2deg(angle))/4, # default rot
				Vector2(1, 1)# default scale
			)
			card.default_display() # animates card to default place
			card_numb += 1
			card.state = 1

func _on_DeckDraw_drawcard():
	$Deck/DeckDraw.deck_size = draw_card()

# adjusts variable when cards are put into/removed from slots
# callback method from BattleCard
func _on_hand_count_change(num_diff: int):
	number_cards_hand += num_diff 
	
func _redraw_hand():
	# scuffed code to make calculations work
	number_cards_hand -= 1
	organize_cards()
	number_cards_hand += 1
	
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
	# create array with size of letter slots
	var temp_arr = []
	for i in range(Saver.letter_count):
		temp_arr.append(null)
		
	# find all cards in slots, place them in respective index
	for card in $Cards.get_children():
		if card.in_slot != -1:
			temp_arr[card.in_slot] = card

	# exclude unfilled slots
	var cards = []
	for card in temp_arr:
		if card != null:
			cards.append(card)
	
	var word = ""
	for card in cards:
		word += card.card_data.name
		
	var valid = _validity(word)
	if true: # idk what happened to dictionary.txt
		var word_data = _word_resolution(cards,word)
		$Player.attack($Enemy, word_data["dmg"], word_data["persistentEffects"])
		print("submitted word: " + word)
		print(word_data)
		print("submitted word is " + ("valid" if valid else "not valid"))
	
	$Enemy.attack($Player) # do this when player ends turn
	
	


func _on_player_damaged(value):
	print("player hp now ", value)
	if value <= 0:
		print("player died!") # do smthn


func _on_enemy_damaged(value):
	print("enemy hp now ", value)
	if value <= 0:
		print("enemy died!") # do smthn
