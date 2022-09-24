extends Node2D

# cards
const CARDSIZE = Vector2(125,175)
const BATTLECARD = preload("res://src/battle/BattleCard.tscn")
const DECK = preload("res://src/cards/Deck.gd")

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
	new_card.default_display()
	new_card.focus_detect = true
	
	organize_cards()
	
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
			card.default_display()
			card_numb += 1
			card.state = 1

func _on_DeckDraw_drawcard():
	$Deck/DeckDraw.deck_size = draw_card()

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

func _ability_resolution(cards):
	var dmg=0
	var draw=0
	var words=0
	var effects=[]
	for card in cards:
		dmg+=card.card_data.damage
		draw+=card.card_data.draw_count
		words+=card.card_data.word_count
		effects.append(card.card_data.effects)
	print(dmg)
	print(effects)
	return



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
	_ability_resolution(cards)
	print("submitted word: " + word)
	print("submitted word is " + ("valid" if valid else "not valid"))
	
