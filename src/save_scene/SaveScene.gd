extends Node2D

var save_screen_button = load("res://src/save_scene/SaveScreenButton.tscn")
var screen_size = null


func _ready():
	# button sizing
	var num_buttons = 4
	var button_height = Sizer.percent_height(15)
	var button_width = Sizer.percent_width(70)
	var padding = Sizer.percent_height(10)
	
	# set position and sizing of each of the save buttons
	for i in range(0, num_buttons):
		var cur_button = get_child(i)
		cur_button.rect_size = Vector2(button_width, button_height)
		cur_button.set_position(Vector2(Sizer.width()/2 - button_width/2, padding + i * (button_height + (Sizer.height() - button_height * num_buttons - padding * 2) / (num_buttons - 1))))
		cur_button.set_button_num(i)
		add_child(cur_button)

# when a save button is pushed, set load file to button number, and go to correct scene
func _on_Save_Button_Pushed(button_num: int):
	var save_exists = Saver.load_data(button_num)
	if save_exists:
		print("go to dungeon floor")
	else:
		get_tree().change_scene("res://src/selection_scene/SelectionScreen.tscn")

