extends TextureButton

signal drawcard()

var deck_size = INF

func _ready():
	pass

func _gui_input(_event):
	if Input.is_action_just_released("leftclick"):
		if deck_size>0:
			emit_signal("drawcard")
			if deck_size == 0:
				print("Deck depleted")
				disabled = true
