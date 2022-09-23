extends MarginContainer

# card states
enum STATES {DEFAULT, MOVE_CARD, CLICKED}

signal on_slot_filled(num_diff)
signal redraw_hand()

# Used for tweening
# preset values
const DRAW_TIME = 0.3
const ORGANIZE_TIME = 0.2
const ZOOM_TIME = 0.05

const ZOOM_SIZE = 1.5
# changing values
var start_pos = Vector2()
var target_pos = Vector2()
var start_scale = Vector2()
var target_scale = Vector2()
var start_rot = 0
var target_rot = 0
var t = 0
var animate_time = 0.3

# default values (used by set_default_display)
var orig_pos = Vector2()
var orig_rot = 0
var orig_scale = Vector2()

# attributes
var focus_detect = false	# true will enlarge card on hover (set to false when in slot)
var in_slot = -1	# -1 if not in slot, else represents current filled slot
var card_data

# Checking card state
var state = STATES.DEFAULT

func _ready():
	pass
	
func _physics_process(delta):
	if t == 0:
		start_pos = rect_position
		start_rot = rect_rotation
		start_scale = rect_scale
	
	match state:
		STATES.DEFAULT:
			pass
		STATES.MOVE_CARD:
			if t <= 1: 
				focus_detect = false
				rect_position = start_pos.linear_interpolate(target_pos, t)
				rect_scale = start_scale * (1-t) + target_scale*t
				rect_rotation = start_rot * (1-t) + target_rot*t
				t += delta/float(animate_time)
			else:
				rect_position = target_pos
				rect_rotation = target_rot
				rect_scale = target_scale
				t = 0
				if in_slot == -1:
					focus_detect = true
				state = STATES.DEFAULT
				
		# When user is dragging card
		STATES.CLICKED:
			rect_position = get_viewport().get_mouse_position() - rect_size * rect_scale /2
			$CardBase/Card.z_index = 0
			if in_slot != -1:
				in_slot = -1
				_hand_count_change(1)
				
func _on_Focus_button_down():
	state = STATES.CLICKED

func _on_Focus_button_up():	# when card is released
	# retrieve currently selected slot
	var slot_node = get_node("../../LetterSlots") 
	var slot_num = slot_node.selected_slot
	
	if slot_num != -1:	# if card released, and there is a selected slot
		for card in get_node("../").get_children():	# remove any existing card in slot
			if card.in_slot == slot_num:
				card.in_slot = -1
				_hand_count_change(1)
		
		# attach card to slot
		in_slot = slot_num
		# update hand count
		_hand_count_change(-1)
		
		# move card to selected slot
		target_pos = slot_node.get_child(slot_num).rect_position
		target_scale = slot_node.get_child(slot_num).rect_scale
		target_rot = 0
		move(ORGANIZE_TIME, target_pos, target_rot, target_scale)
		
		# shift cards/return previous card in slot
		_redraw_hand()
		
		focus_detect = false

	else: # card was released without a selected slot
		slot_num = -1 # move card out of any slot
		_redraw_hand() # return card to hand
		focus_detect = true

func _on_Focus_mouse_entered():
	if focus_detect:
		move(ZOOM_TIME, Vector2(start_pos.x, 530), 0, orig_scale*ZOOM_SIZE)
		$CardBase/Card.z_index = 1

func _on_Focus_mouse_exited():
	if in_slot == -1:
		default_display(ZOOM_TIME)
		$CardBase/Card.z_index = 0

# signal methods
func _redraw_hand():	# places all drawn cards into hand (ignoring slotted cards)
	emit_signal("redraw_hand")
	
func _hand_count_change(diff: int): 	# updates hand_card_count in battle, ensures hand cards are placed correctly
	emit_signal("on_slot_filled", diff)

# setter methods
# should called when instantiating card (sets data on displayed card)
func set_card_data(card_data: CardData):
	self.card_data = card_data	
	$CardBase.set_card_data(card_data)
	
# should be called when instantiating card (sets home location/orientation/size of card)
func set_default_display(orig_pos, orig_rot, orig_scale):
	self.orig_pos = orig_pos
	self.orig_rot = orig_rot
	self.orig_scale = orig_scale


# animate functions
# move card to destination
func move(animate_time = self.animate_time, target_pos = self.target_pos, target_rot = self.target_rot, target_scale = self.target_scale):
	self.animate_time = animate_time
	self.target_pos = target_pos
	self.target_rot = target_rot
	self.target_scale = target_scale
	state = STATES.MOVE_CARD

# move card back to home
func default_display(aniamte_time = self.animate_time): 	# move back to home position
	self.animate_time = animate_time
	target_pos = orig_pos
	target_rot = orig_rot
	target_scale = orig_scale
	state = STATES.MOVE_CARD
