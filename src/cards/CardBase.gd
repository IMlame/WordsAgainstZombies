extends MarginContainer


onready var card_database = preload("res://assets/cards/CardDatabase.gd")
var card_name = 'A'
onready var card_info = card_database.DATA[card_name]

var start_pos = Vector2()
var target_pos = Vector2()
var focus_pos = Vector2()
var start_rot = 0
var target_rot = 0
var t = 0
var draw_time = 0.3
var organize_time = 0.5
var tweening = false
onready var orig_scale = rect_scale*2

var setup = true
var start_scale = Vector2()
var card_pos = Vector2()
var zoom_size = 1.5
var zoom_time = 0.05
var reorganize_neighbours = true
var number_cards_hand = 0
var card_numb = 0
var neighbour_card
var move_neighbour_card_check = false

enum {
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganizeHand
}
var state = InHand

func _ready():
	var card_size = rect_size
	rect_position = Vector2(-500,-500)
	rect_scale *= card_size/$Card.texture.get_size()*1.8
	$Focus.rect_scale *= card_size/$Focus.rect_size*1.5
	
	var damage = str(card_info[0])
	var word = str(card_info[1])
	var draw = str(card_info[2])
	var description = card_info[3]
	$Card/Bar/TopBar/Damage/HBoxContainer/Damage.text = damage
	$Card/Bar/MidBar/CardName/HBoxContainer/CardName.text = card_name
	$Card/Bar/MidBar2/Description/CenterContainer/Description.text = description
	$Card/Bar/BotBar/Word/HBoxContainer/Word.text = word
	$Card/Bar/BotBar/Draw/HBoxContainer/Draw.text = draw
	
func _physics_process(delta):
	match state:
		InHand:
			pass
		InPlay:
			pass
		InMouse:
			pass
		FocusInHand:
			focus_pos = target_pos
			focus_pos.y = 530
			if setup:
				setup()
			if t<=1:
				rect_position = start_pos.linear_interpolate(focus_pos, t)
				rect_rotation = start_rot * (1-t) + 0*t
				rect_scale = start_scale * (1-t) + orig_scale*zoom_size*t
				t += delta/float(zoom_time)
				if reorganize_neighbours:
					reorganize_neighbours = false
					number_cards_hand = $'../../'.number_cards_hand - 1
					if card_numb - 1 >= 0:
						move_neighbour_card(card_numb - 1,true,1)
					if card_numb - 2 >= 0:
						move_neighbour_card(card_numb - 2,true,0.25)
					if card_numb + 1 <= number_cards_hand:
						move_neighbour_card(card_numb + 1,false,1)
					if card_numb + 2 <= number_cards_hand:
						move_neighbour_card(card_numb + 2,false,0.25)
			else:
				rect_position = focus_pos
				rect_rotation = 0
				rect_scale = orig_scale*zoom_size
		MoveDrawnCardToHand: 
			if t <= 1: 
				if tweening == false:
					$Tween.interpolate_property($'.','rect_position',start_pos,
					target_pos,draw_time,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
					$Tween.start()
					tweening = true
				rect_rotation = start_rot * (1-t) + target_rot*t
				t += delta/float(draw_time)
			else:
				rect_position = target_pos
				rect_rotation = target_rot
				state = InHand
				t = 0
		ReOrganizeHand:
			if setup:
				setup()
			if t <= 1: # Always be a 1
				if move_neighbour_card_check:
					move_neighbour_card_check = false
				rect_position = start_pos.linear_interpolate(target_pos, t)
				rect_rotation = start_rot * (1-t) + target_rot*t
				rect_scale = start_scale * (1-t) + orig_scale*t
				t += delta/float(organize_time)
				if reorganize_neighbours == false:
					reorganize_neighbours = true
					if card_numb - 1 >= 0:
						reset_card(card_numb - 1)
					if card_numb - 2 >= 0:
						reset_card(card_numb - 2)
					if card_numb + 1 <= number_cards_hand:
						reset_card(card_numb + 1)
					if card_numb + 2 <= number_cards_hand:
						reset_card(card_numb + 2)
			else:
				rect_position = target_pos
				rect_rotation = target_rot
				rect_scale = orig_scale
				state = InHand
				
func move_neighbour_card(card_numb,left,spread_factor):
	neighbour_card = $'../'.get_child(card_numb)
	if left:
		neighbour_card.target_pos = neighbour_card.card_pos - spread_factor*Vector2(65,0)
	else:
		neighbour_card.target_pos = neighbour_card.card_pos + spread_factor*Vector2(65,0)
	neighbour_card.setup = true
	neighbour_card.state = ReOrganizeHand
	neighbour_card.move_neighbour_card_check = true
	
func reset_card(card_numb):
	if neighbour_card.move_neighbour_card_check == false:
		neighbour_card = $'../'.get_child(card_numb)
		if neighbour_card.state != FocusInHand:
			neighbour_card.state = ReOrganizeHand
			neighbour_card.target_pos = neighbour_card.card_pos
			neighbour_card.setup = true

func setup():
	if setup:
		start_pos = rect_position
		start_rot = rect_rotation
		start_scale = rect_scale
		t = 0
		setup = false

func _on_Focus_mouse_entered():
	match state:
		InHand, ReOrganizeHand:
			state = FocusInHand
			$Card.z_index = 1
			
func _on_Focus_mouse_exited():
	match state:
		FocusInHand:
			state = ReOrganizeHand
			$Card.z_index = 0
