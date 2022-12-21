extends Button

var button_num
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# test if a save exists with the same number as the button. if so, display current stage reached
# if not, display "NEW GAME"
func set_button_num(button_num: int):
	self.button_num = button_num
	var save_exists = Saver.load_data(button_num)
	if save_exists:
		text = "SAVE " + str(button_num) + ": Stage " + str(Saver.dungeon_info.stage)
	else: 
		text = "NEW GAME"


func _on_SaveScreenButton2_pressed(extra_arg_0):
	pass # Replace with function body.


func _on_Save_Button_Pushed(extra_arg_0):
	pass # Replace with function body.
