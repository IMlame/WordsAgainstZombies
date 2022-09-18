extends MarginContainer

onready var card_database = preload("res://assets/cards/CardDatabase.gd")
onready var card_info = card_database.DATA[card_name]

# Card Data
var card_name = 'A'
var damage 
var word_count
var draw_count
var effects
var keywords
	
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
var tweening = false
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
	var card_size = rect_size
	rect_scale *= card_size/$Card.texture.get_size()*1.8
	$Card/Focus.rect_scale *= card_size/$Card/Focus.rect_size*1.5
	
func _physics_process(delta):
	# ensure hitboxing follows card size
	$Card/Focus.rect_scale = rect_scale
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
				if tweening == false:
					$Tween.interpolate_property($'.','rect_position',start_pos,
					target_pos,draw_time,Tween.TRANS_LINEAR,Tween.TRANS_LINEAR)
					$Tween.start()
					tweening = true
				rect_scale = start_scale * (1-t) + target_scale*t
				rect_rotation = start_rot * (1-t) + target_rot*t
				t += delta/float(draw_time)
			else:
				rect_position = target_pos
				rect_rotation = target_rot
				rect_scale = target_scale
				tweening = false
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
			$Card.z_index = 0
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
				$Card.z_index = 3
				state = STATES.MOVE_CARD
			else:
				slot_num = -1
				emit_signal("redraw_hand")
				state = STATES.DEFOCUSED


func set_card_data(card_data: CardData):
	damage = card_data.damage
	card_name = card_data.name
	effects = card_data.effects
	word_count = card_data.word_count
	draw_count = card_data.draw_count
	
	$Card/Bar/TopBar/Damage/HBoxContainer/Damage.set_text(damage as String)
	$Card/Bar/MidBar/CardName/HBoxContainer/CardName.set_text(card_name)
	$Card/Bar/MidBar2/Description/CenterContainer/Description.set_text(effects)
	$Card/Bar/BotBar/Word/HBoxContainer/Word.set_text(word_count as String)
	$Card/Bar/BotBar/Draw/HBoxContainer/Draw.set_text(draw_count as String)
	print(card_data)

func _on_Focus_mouse_entered():
	if focus_detect:
		print("focus")
		state = STATES.FOCUSED
		$Card.z_index = 1
		t = 0

func _on_Focus_mouse_exited():
	if focus_detect:
		state = STATES.DEFOCUSED
		$Card.z_index = 0
		t = 0


func _on_Focus_button_down():
	state = STATES.CLICKED


func _on_Focus_button_up():
	state = STATES.UNCLICKED
	focus_detect = false
