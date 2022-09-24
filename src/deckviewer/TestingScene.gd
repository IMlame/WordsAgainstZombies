extends Node2D

const CARDBASE = preload("res://src/cards/CardBase.tscn")
const POOL = preload("res://assets/pools/DeckViewerTestPool.gd") 
const HCARD_CONTAINER = preload("res://src/deckviewer/HCardContainer.tscn")

var deck = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	var card = CARDBASE.instance()
#	deck.add_child(card)
#	card.rect_position = Vector2(100,100)
#	card.rect_scale = Vector2(1,1)
	randomize()
	for _i in range(120):
		var card_name = POOL.CARDLIST[randi() % POOL.SIZE]
		var card = CardData.new()
		card.load_default(card_name)
		deck.append(card)
	$Screen.load_deck(deck)
