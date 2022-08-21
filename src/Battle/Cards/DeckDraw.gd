extends TextureButton

var Decksize = INF

func _ready():
	pass

func _gui_input(_event):
	if Input.is_action_just_released("leftclick"):
		if Decksize>0:
			Decksize = $'../../'.drawcard()
			if Decksize == 0:
				disabled = true
