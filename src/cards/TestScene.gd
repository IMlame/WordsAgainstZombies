extends Node

const CARD = preload("res://src/cards/TooltipCard.tscn")

func _ready():
	var card_data = CardData.new()
	card_data.load_default("F")
	var new_card = CARD.instance()
	new_card.set_card_data(card_data)
	new_card.set_position(Vector2(300,300))
	add_child(new_card)
