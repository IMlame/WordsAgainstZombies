extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = load("res://assets/Characters/character_art/" + Saver.character_class + "_60x60.png")
	scale = Vector2(150/get_rect().size.x, 150/get_rect().size.x)
	$Healthbar.max_value = Saver.max_health
	$Healthbar.value = Saver.cur_health
	$Healthbar.set_position(Vector2((get_rect().size.x - $Healthbar.get_rect().size.x) / 2, get_rect().size.y + 25))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
