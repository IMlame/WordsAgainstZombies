extends Node2D

const CARDSIZE = Vector2(125,175)
const CARDBASE = preload("res://src/cards/CardBase.tscn")
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
enum {
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganizeHand
}

func _ready():
		randomize()

func draw_card():
	# set up an angle of a card
	angle = PI/2 + card_spread*(float(number_cards_hand)/2 - number_cards_hand)
	# initialize a a drawn card
	var new_card = CARDBASE.instance()
	card_selected = randi() % deck_size
	new_card.card_name = DECK.DECKLIST[card_selected]
	oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
	new_card.start_pos = $Deck.position - CARDSIZE/2
	new_card.target_pos = center_card_oval + oval_angle_vector - CARDSIZE
	new_card.card_pos = new_card.target_pos
	new_card.start_rot = 0
	new_card.target_rot = (90 - rad2deg(angle))/4
	new_card.rect_scale *= CARDSIZE/new_card.rect_size
	new_card.state = MoveDrawnCardToHand
	card_numb = 0
	
	for card in $Cards.get_children(): # reorganise hand
		angle = PI/2 + card_spread*(float(number_cards_hand)/2 - card_numb)
		oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
		card.target_pos = center_card_oval + oval_angle_vector - CARDSIZE
		card.card_pos = card.target_pos 
		card.start_rot = card.rect_rotation
		card.target_rot = (90 - rad2deg(angle))/4
		card_numb += 1
		if card.state == InHand:
			card.state = ReOrganizeHand
			card.start_pos = card.rect_position
		elif card.state == MoveDrawnCardToHand:
			card.start_pos = card.target_pos - ((card.target_pos - card.rect_position)/(1-card.t))
	$Cards.add_child(new_card)
	DECK.DECKLIST.erase(DECK.DECKLIST[card_selected])
	angle += 0.25
	deck_size -= 1
	number_cards_hand += 1
	card_numb += 1
	return deck_size

func resetraise():
	for i in range(card_numb):
		$Cards.get_child(i).raise()


func _on_DeckDraw_drawcard():
	$Deck/DeckDraw.deck_size = draw_card()
