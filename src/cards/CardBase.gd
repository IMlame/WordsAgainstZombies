extends MarginContainer

const DEFAULT = preload("res://assets/temp_peter/dictionary.txt").DATA
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
var start_rot = 0
var target_rot = 0
var t = 0
var draw_time = 0.3
var organize_time = 0.5
var zoom_size = 1.5
var zoom_time = 0.05
var tweening = false
onready var orig_scale = rect_scale*2

# Checking card state
var move_card = false
var drawn_card = true
var focused = false
var defocused = false
var focus_detect = false	# true will enlarge card on fhover
var setup = true

func _ready():
	var card_size = rect_size
	rect_position = Vector2(-500,-500)
	rect_scale *= card_size/$Card.texture.get_size()*1.8
	$Focus.rect_scale *= card_size/$Focus.rect_size*1.5
	
func _physics_process(delta):
	if !drawn_card:
		if t <= 1: 
			if tweening == false:
				$Tween.interpolate_property($'.','rect_position',start_pos,
				target_pos,draw_time,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
				$Tween.start()
				tweening = true
			rect_rotation = start_rot * (1-t) + target_rot*t
			t += delta/float(draw_time)
		else:
			start_pos = target_pos
			rect_position = target_pos
			rect_rotation = target_rot
			drawn_card = true
			t = 0
			
	if move_card:
		if t <= 1: 
			if tweening == false:
				$Tween.interpolate_property($'.','rect_position',start_pos,
				target_pos,draw_time,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
				$Tween.start()
				tweening = true
			rect_rotation = start_rot * (1-t) + target_rot*t
			t += delta/float(draw_time)
		else:
			start_pos = target_pos
			rect_position = target_pos
			rect_rotation = target_rot
			move_card = false
			t = 0
		
	# When users hovers mouse and it is not moving
	if focused and !move_card and drawn_card:
		focus_pos = target_pos
		focus_pos.y = 530
		if setup:
			setup_position()
		if t<=1:
			rect_position = start_pos.linear_interpolate(focus_pos, t)
			rect_rotation = start_rot * (1-t) + 0*t
			rect_scale = start_scale * (1-t) + orig_scale*zoom_size*t
			t += delta/float(zoom_time)
		else:
			rect_position = focus_pos
			rect_rotation = 0
			rect_scale = orig_scale*zoom_size
	
	# When user moves mouse away and it is not moving
	if defocused and !move_card and drawn_card:
		if t<=1:
			rect_position = start_pos.linear_interpolate(target_pos, t)
			rect_rotation = start_rot * (1-t) + target_rot*t
			rect_scale = start_scale * (1-t) + orig_scale*t
			t += delta/float(organize_time)
		else:
			rect_position = target_pos
			rect_rotation = target_rot
			rect_scale = orig_scale
			focused = false
			defocused = false
			t = 0

func setup_position():
	if setup:
		start_pos = rect_position
		start_rot = rect_rotation
		start_scale = rect_scale
		t = 0
		setup = false
			

func string_valid(string: String):
	
	
	return true
	

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
		focused = true
		$Card.z_index = 1

func _on_Focus_mouse_exited():
	if focus_detect:
		defocused = true
		$Card.z_index = 0
