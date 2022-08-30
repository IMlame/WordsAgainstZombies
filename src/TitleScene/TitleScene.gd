extends Node2D


var titleScreenLabel = load("res://src/TitleScene/TitleScreenButton.tscn")
var screen_size = null
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	var start_game_label = titleScreenLabel.instance()

	start_game_label.position = Vector2(Sizer.percent_width(5), Sizer.percent_height(55))
	start_game_label.init("Start Game")
	add_child(start_game_label)
	start_game_label.connect("title_screen_button_pushed", self, "_on_button_pushed")
	
	var settings_label = titleScreenLabel.instance()
	settings_label.position = Vector2(Sizer.percent_width(5), Sizer.percent_height(70))
	settings_label.init("Settings")
	add_child(settings_label)
	settings_label.connect("title_screen_button_pushed", self, "_on_button_pushed")
	
	var quit_label = titleScreenLabel.instance()
	quit_label.position = Vector2(Sizer.percent_width(5), Sizer.percent_height(85))
	quit_label.init("Quit")
	add_child(quit_label)
	quit_label.connect("title_screen_button_pushed", self, "_on_button_pushed")

func _on_button_pushed(button_name: String):
	match button_name:
		"Start Game":
			get_tree().change_scene("res://src/SaveScene/SaveScene.tscn")
		"Settings":
			print("settings")
		"Quit":
			get_tree().quit()
			
