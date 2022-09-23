extends HBoxContainer

const CARDBASE = preload("res://src/cards/CardBase.tscn")
const POOL = preload("res://assets/pools/DeckViewerTestPool.gd") 
const CARD_MARGIN = 50
var card_num = 5


func _ready():
	var viewport = get_viewport_rect().size
	var base = CARDBASE.instance()
	var card_size = base.get_size()
	add_constant_override("separation", CARD_MARGIN)		# Set margin between cards
	set_custom_minimum_size(Vector2(viewport.x, card_size.y + 50))
	_set_position(Vector2(0,0))
	set_alignment(ALIGN_CENTER)

func load_cards(cards):
	var count = 0
	for card in cards:
		if count < card_num:
			var new_card = CARDBASE.instance()
			new_card.set_card_data(card)
			new_card.set_custom_minimum_size(new_card.get_size())
			add_child(new_card)
			count += 1
