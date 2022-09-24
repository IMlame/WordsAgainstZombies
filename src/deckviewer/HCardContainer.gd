extends HBoxContainer

const TOOLTIP_CARD = preload("res://src/cards/TooltipCard.tscn")
const POOL = preload("res://assets/pools/DeckViewerTestPool.gd") 
const CARD_MARGIN = 50
var card_num = 5


func _ready():
	var viewport = get_viewport_rect().size
	var base = TOOLTIP_CARD.instance()
	var card_size = base.get_size()
	add_constant_override("separation", CARD_MARGIN)		# Set margin between cards
	set_custom_minimum_size(Vector2(viewport.x, card_size.y + 50))
	_set_position(Vector2(0,0))
	set_alignment(ALIGN_CENTER)

func load_cards(cards):
	var count = 0
	for card in cards:
		if count < card_num:
			var new_card = TOOLTIP_CARD.instance()
			new_card.set_card_data(card)
			add_child(new_card)
			new_card.set_custom_minimum_size(new_card.get_size())
			if card.keywords == []:
				new_card.set_process(false)
			new_card._set_position(new_card.get_position() + Vector2(0, get_position().y))
			count += 1
