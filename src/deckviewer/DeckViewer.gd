extends Control

# Users of this scene must feed in an array of CardData using load_deck

const TOOLTIP_CARD = preload("res://src/cards/TooltipCard.tscn")
const HCARD_CONTAINER = preload("res://src/deckviewer/HCardContainer.tscn")
const BLIND = preload("res://src/deckviewer/Blind.tscn")
const MARGIN = 50

var deck := []
var hor_num_cards := 5

func _ready():
	set_size(get_viewport_rect().size)
	$ScrollContainer.set_custom_minimum_size(get_size())
	$ScrollContainer/VBoxContainer.set_custom_minimum_size(get_size())
	$ScrollContainer/VBoxContainer/TopMargin.set_custom_minimum_size(Vector2(get_size().x,
																	$ScrollContainer/VBoxContainer/TopMargin.get_size().y))
	$ScrollContainer/VBoxContainer.add_constant_override("separation", MARGIN)

# Signal from return button
func _on_Return_pressed():
	get_tree().quit()

# Load deck to deckviewer scene
func load_deck(deck):
	self.deck = deck
	deck.sort_custom(CardData, "sort_name_ascending")
	var container_num = deck.size()/hor_num_cards			# horizontal container - 1
	if container_num == float(deck.size())/hor_num_cards:
		container_num -= 1
	for i in range(container_num):
		var new_container = HCARD_CONTAINER.instance()
		$ScrollContainer/VBoxContainer.add_child(new_container)
		new_container.load_cards(deck.slice(i*hor_num_cards,(i+1)*hor_num_cards-1))
		for child in new_container.get_children():
			child.connect("press_detected", self, "_on_TooltipCard_press_detected")
	var new_container = HCARD_CONTAINER.instance()
	new_container.load_cards(deck.slice(container_num*hor_num_cards, deck.size() - 1))
	$ScrollContainer/VBoxContainer.add_child(new_container)
	
func _on_TooltipCard_press_detected(card_data):
	var blind = BLIND.instance()
	add_child(blind)
	blind.get_child(0).set_card_data(card_data)
