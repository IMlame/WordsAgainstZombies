extends Node2D

var saveScreenButton = load("res://src/SaveScene/SaveScreenButton.tscn")
var screen_size = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var num_buttons = 4
	var button_height = Sizer.percent_height(15)
	var button_width = Sizer.percent_width(70)
	var padding = Sizer.percent_height(10)
	
	for i in range(1, num_buttons + 1):
		var saveButton = saveScreenButton.instance()
		saveButton.get_child(0).rect_size = Vector2(button_width, button_height)
		saveButton.position = Vector2(Sizer.width()/2 - button_width/2, padding + (i-1) * (button_height + (Sizer.height() - button_height * num_buttons - padding * 2) / (num_buttons - 1)))
		saveButton.init(i)
		saveButton.connect("save_screen_button_pushed", self, "_on_button_pushed")
		add_child(saveButton)


func _on_button_pushed(button_num: int, new: bool):
	Saver.load_data(button_num)
	if new:
		print("go to character select")
	else:
		print("go to dungeon floor")
