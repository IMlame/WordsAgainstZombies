extends Node2D

const CARDBASE = preload("res://src/Battle/Cards/CardBase.tscn")
const POOL = preload("res://assets/Pools/TempShopPool.gd") 

var deck = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	var card = CARDBASE.instance()
#	deck.add_child(card)
#	card.rect_position = Vector2(100,100)
#	card.rect_scale = Vector2(1,1)
	for _i in range(10):
		var card_name = POOL.CARDLIST[randi() % POOL.SIZE]
		var card = CardData.new()
		card.load_default(card_name)
		deck.append(card)
	$DeckViewer.load_deck(deck)
	print(deck)

func _process(delta):
	pass
