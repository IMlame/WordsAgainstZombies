extends Node2D

var Shop = preload("res://src/Shop/Shop.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var temp = Shop.instance();
	$".".add_child(temp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
