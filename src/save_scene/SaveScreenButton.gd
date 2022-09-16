extends Button

var button_num
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_button_num(button_num: int):
	self.button_num = button_num
	var save_exists = Saver.load_data(button_num)
	if save_exists:
		text = "SAVE " + str(button_num) + ": Stage " + str(Saver.stage)
	else: 
		text = "NEW GAME"


func _on_Save_Button_Pushed(button_num: int):
	pass # Replace with function body.
