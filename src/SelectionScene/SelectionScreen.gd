extends Node2D

var ScreenSize = null
var Background1 = preload("res://assets/temp_peter/Background1.jpg")
var Background2 = preload("res://assets/temp_peter/Background2.jpg")
var Background3 = preload("res://assets/temp_peter/Background3.jpg")
var Background4 = preload("res://assets/temp_peter/Background4.jpg")
var CharacterData = preload("res://assets/Characters/CharacterData.gd").CHARACTERS
var texture
var hasChanged = false

func _ready():
	ScreenSize = get_viewport().size
	print(texture)

#Change text and art corresponding to Character1
func _on_Character1_pressed():
	$Background.set_texture(Background2)
	change_views("Luke")
	
#Change text and art corresponding to Character2
func _on_Character2_pressed():
	$Background.set_texture(Background3)
	change_views("Matthew")

#Change text and art corresponding to Character3
func _on_Character3_pressed():
	$Background.set_texture(Background4)
	change_views("Evan")

func change_views(name):
	# Scale up the CharacterArt to match default picture
	if !hasChanged:
		hasChanged = true
		$CharacterArt.scale = Vector2(3,3)
	$Name.text = name
	$Health.text = "Health:" + CharacterData[name][0] as String
	$Gold.text = "Gold:" + CharacterData[name][1] as String
	$Trait.text = CharacterData[name][2]
	#convert string to texture object
	texture = load(CharacterData[name][4])
	$CharacterArt.set_texture(texture)


func _on_DeckViewer_pressed():
	pass # Replace with function body.


func _on_Start_pressed():
	pass # Replace with function body.
