extends Node2D

const CardSize = Vector2(125,175)
const CardBase = preload("res://src/Battle/Cards/CardBase.tscn")
const Deck = preload("res://src/Battle/Cards/Deck.gd")
var CardSelected = []
onready var DeckSize = Deck.DeckList.size()

#Getting position to put in hand after draw
onready var CenterCardOval = get_viewport().size * Vector2(0.5, 1.33)
onready var Hor_rad = get_viewport().size.x * 0.55
onready var Ver_rad = get_viewport().size.y * 0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = 0
var CardSpread = 0.15
var OvalAngleVector = Vector2()
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

func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instance()
	CardSelected = randi() % DeckSize
	new_card.Cardname = Deck.DeckList[CardSelected]
	OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
	new_card.startpos = $Deck.position - CardSize/2
	new_card.targetpos = CenterCardOval + OvalAngleVector - CardSize
	new_card.Cardpos = new_card.targetpos
	new_card.startrot = 0
	new_card.targetrot = (90 - rad2deg(angle))/4
	new_card.rect_scale *= CardSize/new_card.rect_size
	new_card.state = MoveDrawnCardToHand
	Card_Numb = 0
	for Card in $Cards.get_children(): # reorganise hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		Card.targetpos = CenterCardOval + OvalAngleVector - CardSize
		Card.Cardpos = Card.targetpos 
		Card.startrot = Card.rect_rotation
		Card.targetrot = (90 - rad2deg(angle))/4
		Card_Numb += 1
		if Card.state == InHand:
			Card.state = ReOrganizeHand
			Card.startpos = Card.rect_position
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.rect_position)/(1-Card.t))
	$Cards.add_child(new_card)
	Deck.DeckList.erase(Deck.DeckList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
	Card_Numb += 1
	return DeckSize

func resetraise():
	for i in range(Card_Numb):
		$Cards.get_child(i).raise()
