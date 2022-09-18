extends TextureButton

const OUTLINE_TEXTURE = preload("res://assets/Cards/card_outline.png")

signal slot_hovered(slot_num)
signal slot_unhovered
signal slot_change(hand_count_diff)

var slot_num = -1
var above = false

func _ready():
	# identify slot number
	var slots = get_node("../")
	for i in range(0, len(slots.get_children())):
		if slots.get_child(i) == self:
			slot_num = i
			print(slot_num)
			
	var outline = Sprite.new()
	outline.texture = OUTLINE_TEXTURE
	outline.position += outline.get_rect().size/2
	outline.z_index = -1
	add_child(outline)

func _process(delta):
	var loc = get_viewport().get_mouse_position()
	# if mouse is in slot area, and hasn't been hovering already, highlight
	if(_v1_bigger(loc, rect_position) and _v1_smaller(loc, rect_position + rect_size * rect_scale)):
		if !above:
			above = true
			get_child(0).z_index = 1
			emit_signal("slot_hovered", slot_num)
	# if mouse moves away, remove highlight
	elif above:
		above = false
		get_child(0).z_index = -1
		emit_signal("slot_unhovered")

func _v1_bigger(v1: Vector2, v2: Vector2):
	return v1.x > v2.x and v1.y > v2.y
	
func _v1_smaller(v1: Vector2, v2: Vector2):
	return v1.x < v2.x and v1.y < v2.y
