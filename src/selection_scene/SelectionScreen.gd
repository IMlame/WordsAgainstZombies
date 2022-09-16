extends Node2D

const BACKGROUND1 = preload("res://assets/temp_peter/background1.jpg")
const BACKGROUND2 = preload("res://assets/temp_peter/background2.jpg")
const BACKGROUND3 = preload("res://assets/temp_peter/background3.jpg")
const BACKGROUND4 = preload("res://assets/temp_peter/background4.jpg")
const CHARACTERDATA = preload("res://assets/characters/CharacterData.gd").DATA

var screen_size = null
var texture
var has_changed = false

func _ready():
	screen_size = get_viewport().size
	print(texture)

#Change text and art corresponding to Character1
func _on_Character1_pressed():
	$Background.set_texture(BACKGROUND2)
	change_views("Luke")
	
#Change text and art corresponding to Character2
func _on_Character2_pressed():
	$Background.set_texture(BACKGROUND3)
	change_views("Matthew")

#Change text and art corresponding to Character3
func _on_Character3_pressed():
	$Background.set_texture(BACKGROUND4)
	change_views("Evan")

func change_views(name):
	# Scale up the CharacterArt to match default picture
	if !has_changed:
		has_changed = true
		$CharacterArt.scale = Vector2(3,3)
	$Name.set_text(name)
	$Health.set_text("Health:" + CHARACTERDATA[name][0] as String)
	$Gold.set_text("Gold:" + CHARACTERDATA[name][1] as String)
	$Trait.set_text(CHARACTERDATA[name][2])
	#convert string to texture object
	texture = load(CHARACTERDATA[name][4])
	$CharacterArt.set_texture(texture)


func _on_DeckViewer_pressed():
	pass # Replace with function body.


func _on_Start_pressed():
	pass # Replace with function body.
