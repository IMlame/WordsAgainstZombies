extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = Saver.max_health
	value = Saver.cur_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if value != Saver.cur_health:
		value = Saver.cur_health
