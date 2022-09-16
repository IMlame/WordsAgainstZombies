extends Node2D


var titleScreenLabel = load("res://src/title_scene/TitleScreenButton.tscn")
onready var buttons = get_tree().get_nodes_in_group("TitleScreenButtons")
var screen_size = null
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	get_child(2).set_position(Vector2(Sizer.percent_width(5), Sizer.percent_height(55)))
	get_child(3).set_position(Vector2(Sizer.percent_width(5), Sizer.percent_height(70)))
	get_child(4).set_position(Vector2(Sizer.percent_width(5), Sizer.percent_height(85)))

func _on_NewGame_pressed():
	get_tree().change_scene("res://src/save_scene/SaveScene.tscn")

func _on_Settings_pressed():
	print("settings")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Button_Hovered():
	$Background.texture = load("res://assets/background/background2.png")
	
func _on_Button_Unhovered():
	$Background.texture = load("res://assets/background/background1.png")
