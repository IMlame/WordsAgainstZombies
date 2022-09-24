extends Control

# Users of this scene must feed in an array of CardData using load_deck

const TOOLTIP_CARD = preload("res://src/cards/TooltipCard.tscn")			# Card structure used in this scene
const HCARD_CONTAINER = preload("res://src/deckviewer/HCardContainer.tscn")	# Horizontal strip containing cards
const BLIND = preload("res://src/deckviewer/Blind.tscn")					# Scene with blind and enlarged card
const MARGIN = 50															# Vertical margin between HCardContainers

var deck := []
var hor_num_cards := 5

func _ready():
	set_size(get_viewport().get_size())							# Set size of Screen
	$ScrollBox.set_custom_minimum_size(get_size())				# Set minimum size of ScrollBox	
	$ScrollBox/VerticalBox.set_custom_minimum_size(get_size())	# Set minimum size of VerticalBox
	$ScrollBox/VerticalBox/TopMargin.set_custom_minimum_size(Vector2(get_size().x,	
																$ScrollBox/VerticalBox/TopMargin.get_size().y)) # Set minimum size of TopMargin
	$ScrollBox/VerticalBox.add_constant_override("separation", MARGIN) 	# Set margin between HCardContainers 

# Load deck to deckviewer scene
func load_deck(deck):
	self.deck = deck
	deck.sort_custom(CardData, "sort_name_ascending")		# sort the deck
	var container_num = deck.size()/hor_num_cards			# horizontal container - 1
	if container_num == float(deck.size())/hor_num_cards:	# keeping property of container_num consistent
		container_num -= 1
	for i in range(container_num):							# generate HCardContainer with max card numbers
		var new_container = HCARD_CONTAINER.instance()
		$ScrollBox/VerticalBox.add_child(new_container)
		new_container.load_cards(deck.slice(i*hor_num_cards,(i+1)*hor_num_cards-1))
		for child in new_container.get_children():										# Connect click signal
			child.connect("press_detected", self, "_on_TooltipCard_press_detected")
	var new_container = HCARD_CONTAINER.instance()										# Last Horizontal container
	$ScrollBox/VerticalBox.add_child(new_container)
	new_container.load_cards(deck.slice(container_num*hor_num_cards, deck.size() - 1))
	for child in new_container.get_children():											# Connect click signal
		child.connect("press_detected", self, "_on_TooltipCard_press_detected")	

# Make enlarged card with blind when clicked
func _on_TooltipCard_press_detected(card_data):
	var blind = BLIND.instance()
	add_child(blind)
	blind.set_card_data(card_data)

# Quit when return button is pressed
func _on_Return_pressed():
	get_tree().quit()
