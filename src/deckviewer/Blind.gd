extends TextureButton

func _ready():
	set_size(get_viewport().get_size())
	$BigCard.set_scale(Vector2(1,1) * get_size().y / $BigCard.get_size().y)
	$BigCard.set_position(Vector2((get_size().x - $BigCard.get_size().x)/2,0))

func _on_Blind_pressed():
	queue_free()
