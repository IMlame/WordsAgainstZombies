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
var move_card = false
var t = 0
var tweening = false

func _ready():
		randomize()
		
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
	new_card.rect_position = $Deck.position - CARDSIZE/2
	new_card.target_pos = center_card_oval + oval_angle_vector - CARDSIZE
	new_card.card_pos = new_card.target_pos
	new_card.start_rot = 0
	new_card.target_rot = (90 - rad2deg(angle))/4
	new_card.rect_scale *= CARDSIZE/new_card.rect_size
	new_card.target_scale = new_card.rect_scale
	new_card.focus_detect = true
	new_card.connect("on_slot_filled", self, "_on_hand_count_change")
	new_card.connect("redraw_hand", self, "_redraw_hand")
	$Cards.add_child(new_card)
	move_card = true
	
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
			card.target_pos = center_card_oval + oval_angle_vector - CARDSIZE
			card.card_pos = card.target_pos 
			card.start_rot = card.rect_rotation
			card.target_rot = (90 - rad2deg(angle))/4
			card.target_scale = card.rect_scale
			card_numb += 1
			card.state = 1

func _on_DeckDraw_drawcard():
	$Deck/DeckDraw.deck_size = draw_card()

func _on_hand_count_change(num_diff: int):
	number_cards_hand += num_diff

func _redraw_hand():
	number_cards_hand -= 1
	organize_cards()
	number_cards_hand += 1
