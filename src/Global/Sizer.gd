extends Node2D


var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func percent_width(percent: float):
	return screen_size.x * percent * .01
	
func percent_height(percent: float):
	return screen_size.y * percent * .01

func width():
	return screen_size.x

func height():
	return screen_size.y
