extends Node2D


var titleScreenLabel = load("res://src/TitleScreenButton.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var label = titleScreenLabel.instance()
	label.init("sneeze")
	add_child(label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
