extends TextureButton


# Used for tweening
var start_pos = Vector2()
var target_pos = Vector2()
var focus_pos = Vector2()
var card_pos = Vector2()
var start_scale = Vector2()
var target_scale = Vector2()
var start_rot = 0
var target_rot = 0
var t = 0
var draw_time = 0.3
var organize_time = 0.5
var zoom_size = 1.5
var zoom_time = 0.05
onready var orig_scale = rect_scale*2

# card dstates
enum STATES {DEFAULT, MOVE_CARD, FOCUSED, DEFOCUSED, CLICKED, UNCLICKED}

signal on_slot_filled(num_diff)
signal redraw_hand()

# Checking card state
var state = STATES.DEFAULT

var focus_detect = false	# true will enlarge card on fhover

var setup = true	# setting info of card when focused for first time

var in_slot = -1	# -1 if not in slot, else represents current filled slot

func _ready():
	rect_scale *= rect_size/$CardBase/Card.texture.get_size()*1.8
	$CardBase/Card.scale = rect_scale
	
func _physics_process(delta):
	$CardBase/Card.scale = rect_scale
	# before tweening, record starting data
	if t == 0:
		start_pos = rect_position
		start_rot = rect_rotation
		start_scale = rect_scale
	
	match state:
		STATES.DEFAULT:
			pass
		STATES.MOVE_CARD:
			if t <= 1: 
				rect_position = start_pos.linear_interpolate(target_pos, t)
				rect_scale = start_scale * (1-t) + target_scale*t
				rect_rotation = start_rot * (1-t) + target_rot*t
				t += delta/float(draw_time)
			else:
				rect_position = target_pos
				rect_rotation = target_rot
				rect_scale = target_scale
				t = 0
				state = STATES.DEFAULT
		# When users hovers mouse
		STATES.FOCUSED:
			focus_pos = target_pos
			focus_pos.y = 530
			if t<=1:
				rect_position = start_pos.linear_interpolate(focus_pos, t)
				rect_rotation = start_rot * (1-t) + 0*t
				rect_scale = start_scale * (1-t) + orig_scale*zoom_size*t
				t += delta/float(zoom_time)
			else:
				rect_position = focus_pos
				rect_rotation = 0
				rect_scale = orig_scale*zoom_size
				t = 0
				state = STATES.DEFAULT
	
		# When user moves mouse away
		STATES.DEFOCUSED:
			if t<=1:
				rect_position = start_pos.linear_interpolate(target_pos, t)
				rect_rotation = start_rot * (1-t) + target_rot*t
				rect_scale = start_scale * (1-t) + orig_scale*t
				t += delta/float(zoom_time)
			else:
				rect_position = target_pos
				rect_rotation = target_rot
				rect_scale = orig_scale
				t = 0
				state = STATES.DEFAULT
			
		# When user is dragging card
		STATES.CLICKED:
			focus_detect = true
			rect_position = get_viewport().get_mouse_position() - rect_size * rect_scale /2
			$CardBase/Card.z_index = 0
			if in_slot != -1:
				in_slot = -1
				emit_signal("on_slot_filled", 1)

		STATES.UNCLICKED:
			var slot_node = get_node("../../LetterSlots")
			var slot_num = slot_node.selected_slot
			if slot_num != -1:
				target_pos = slot_node.get_child(slot_num).rect_position
				target_scale = slot_node.get_child(slot_num).rect_scale
				target_rot = 0
				in_slot = slot_num
				emit_signal("on_slot_filled", -1)
				emit_signal("redraw_hand")
				$CardBase/Card.z_index = 2
				state = STATES.MOVE_CARD
			else:
				slot_num = -1
				emit_signal("redraw_hand")
				state = STATES.DEFOCUSED

func set_card_data(card_data: CardData):
	$CardBase.set_card_data(card_data)

func _on_BattleCard_mouse_entered():
	print(focus_detect)
	if focus_detect:
		print("focus")
		state = STATES.FOCUSED
		$CardBase/Card.z_index = 1
		t = 0

func _on_BattleCard_mouse_exited():
	if focus_detect:
		state = STATES.DEFOCUSED
		$CardBase/Card.z_index = 0
		t = 0


func _on_Focus_button_down():
	state = STATES.CLICKED


func _on_Focus_button_up():
	state = STATES.UNCLICKED
	focus_detect = false
