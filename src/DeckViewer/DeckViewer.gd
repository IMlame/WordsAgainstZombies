extends Node2D

# Users of this scene must feed in reference of the deck

var deck

func _ready():
	pass

func _process(delta):
	pass

# Signal from return button
func _on_Return_pressed():
	get_tree().quit()

#load deck to deckviewer scene
func load_deck(deck):
	self.deck = deck
