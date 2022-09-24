extends HBoxContainer

const TOOLTIP_CARD = preload("res://src/cards/TooltipCard.tscn")	# Card structure used in this scene
const CARD_MARGIN = 50												# Margin between cards
const CARD_NUM = 5													# Max number of cards holded by strip

func _ready():
	var viewport = get_viewport().get_size()
	var base = TOOLTIP_CARD.instance()
	var card_size = base.get_size()
	add_constant_override("separation", CARD_MARGIN)				# Set margin between cards
	set_custom_minimum_size(Vector2(viewport.x, card_size.y + 50))	# Set minimum size of the container
	_set_position(Vector2(0,0))										# Reset position of Container to origin
	$LeftMargin.set_custom_minimum_size(Vector2((card_size.x + CARD_MARGIN)* 5/2 - CARD_MARGIN, card_size.y + 50)) # Set left margin of container

# Loads card to container
func load_cards(cards):
	var count = 0
	for card in cards:
		if count < CARD_NUM:										# Restricts num of cards
			var new_card = TOOLTIP_CARD.instance()
			add_child(new_card)
			new_card.set_card_data(card)							# Set card data
			if card.keywords == []:									# Turn off tooltip when card has no keywords
				new_card.set_process(false)
			new_card._set_position(new_card.get_position() + Vector2(0, get_position().y))	# Set position of card
			count += 1
