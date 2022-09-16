extends Node2D


var titleScreenLabel = load("res://src/title_scene/TitleScreenButton.tscn")
onready var buttons = get_tree().get_nodes_in_group("TitleScreenButtons")
var screen_size = null

func _ready():
	# set size of Start Game button, Settings button, and Quit button
	get_child(2).set_position(Vector2(Sizer.percent_width(5), Sizer.percent_height(55)))
	get_child(3).set_position(Vector2(Sizer.percent_width(5), Sizer.percent_height(70)))
	get_child(4).set_position(Vector2(Sizer.percent_width(5), Sizer.percent_height(85)))

func _on_NewGame_pressed():
	get_tree().change_scene("res://src/save_scene/SaveScene.tscn")

func _on_Settings_pressed():
	print("settings")

func _on_Quit_pressed():
	get_tree().quit()
	
# changes background when one of the buttons is hoverred
func _on_Button_Hovered():
	$Background.texture = load("res://assets/background/background2.png")
	
func _on_Button_Unhovered():
	$Background.texture = load("res://assets/background/background1.png")
