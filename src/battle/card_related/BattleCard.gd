extends MarginContainer

# card states
enum ANIMATE_STATES {DEFAULT, MOVE_CARD, CLICKED}
const CARD_STATES = CardStateEnum.CARD_STATES

const CARD_IMG = preload("res://assets/cards/card.png")
const CARD_BACK_IMG = preload("res://assets/cards/card_back.png")

# hand preset values
onready var center_card_oval = get_viewport().size * Vector2(0.5, 1.2)
onready var hor_rad = get_viewport().size.x * 0.55
onready var ver_rad = get_viewport().size.y * 0.4
const CARD_SPREAD = 0.15

# Used for tweening
# preset values
const DRAW_TIME = 0.3
const ORGANIZE_TIME = 0.2
const SHUFFLE_TIME = 0.3
const DISCARD_TIME = 0.2
const PLAY_TIME = 1
const ZOOM_TIME = 0.05

const ZOOM_SIZE = 1.5

# signals
signal slot_changed(added, removed)

# changing values
var start_pos = Vector2()
var target_pos = Vector2()
var start_scale = Vector2()
var target_scale = Vector2()
var start_rot = 0
var target_rot = 0
var t = 0
var animate_time = 0.3

var in_hand_angle = 0
var in_hand_pos = Vector2()

# for moving to
var deck_sprite = null
var discard_sprite = null

# attributes
var focus_detect = false	# true will enlarge card on hover (set to false when in slot)
var clickable = false 	# true will allow card to be dragged
var in_slot = -1	# -1 if not in slot, else represents current filled slot
var card_data

# Checking card state
var animate_state = ANIMATE_STATES.DEFAULT
var card_state = CARD_STATES.NONE

func _ready():
	pass
	
func _physics_process(delta):
	if t == 0:
		start_pos = rect_position
		start_rot = rect_rotation
		start_scale = rect_scale
	
	match animate_state:
		ANIMATE_STATES.DEFAULT:
			pass
		ANIMATE_STATES.MOVE_CARD:
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
				if card_state == CARD_STATES.HAND:
					focus_detect = true
				animate_state = ANIMATE_STATES.DEFAULT
				
		# When user is dragging card
		ANIMATE_STATES.CLICKED:
			rect_position = get_viewport().get_mouse_position() - rect_size * rect_scale /2
			$CardBase/Card.z_index = 0
				
func _on_Focus_button_down():
	if clickable:
		animate_state = ANIMATE_STATES.CLICKED

func _on_Focus_button_up():	# when card is released
	if clickable:
		# retrieve currently selected slot
		var slot_node = get_node("../../LetterSlots") 
		var slot_num = slot_node.selected_slot
		
		if slot_num != -1:	# if card released, and there is a selected slot
			var other_card = null
			for card in get_node("../").get_children():	# remove any existing card in slot
				if card.in_slot == slot_num and card != self:
					card.in_slot = -1
					other_card = card
			
			# attach card to slot
			in_slot = slot_num
			emit_signal("slot_changed", self, other_card) # set card states and move cards
			focus_detect = false
			
		else: # card was released without a selected slot
			if in_slot != -1:
				in_slot = -1
				emit_signal("slot_changed", null, self)
				
			move(ORGANIZE_TIME, in_hand_pos, in_hand_angle, Vector2(1, 1))
			focus_detect = true

func _on_Focus_mouse_entered():
	if focus_detect:
		move(ZOOM_TIME, Vector2(start_pos.x, 530), 0, Vector2(1, 1) * ZOOM_SIZE)
		$CardBase/Card.z_index = 1

func _on_Focus_mouse_exited():
	if in_slot == -1 and (card_state == CARD_STATES.HAND):
		move(ZOOM_TIME, in_hand_pos, in_hand_angle, Vector2(1, 1))
		$CardBase/Card.z_index = 0


# setter methods
# should called when instantiating card (sets data on displayed card)
func set_card_data(card_data: CardData):
	self.card_data = card_data	
	$CardBase.set_card_data(card_data)
	
func set_locations(deck_sprite: Node2D, discard_sprite: Node2D):
	self.deck_sprite = deck_sprite
	self.discard_sprite = discard_sprite

# animate functions
# move card to destination
func move(animate_time = self.animate_time, target_pos = self.target_pos, target_rot = self.target_rot, target_scale = self.target_scale):
	self.animate_time = animate_time
	self.target_pos = target_pos
	self.target_rot = target_rot
	self.target_scale = target_scale
	animate_state = ANIMATE_STATES.MOVE_CARD
	
func update_card(deck: Array, hand: Array, discard: Array, slot: Array, played: Array, type: int, card_num: int):
	# prevent card from blowing up when not in hand
	if type != CARD_STATES.HAND:
		focus_detect = false
	
	if type != CARD_STATES.HAND and type != CARD_STATES.SLOTS:
		clickable = false
	else:
		clickable = true
	
	# reset data on card if not in slot
	if type != CARD_STATES.SLOTS:
		in_slot = -1
	
	# show back of card if in deck
	if type != CARD_STATES.DECK:
		$Back.visible = false
	else:
		$Back.visible = true
		
	# if card isn't in correct position, animate to position
	if type == CARD_STATES.DECK and card_state != CARD_STATES.DECK:
		var scale = deck_sprite.scale
		move(SHUFFLE_TIME, deck_sprite.position - rect_size * scale / 2, 0, scale)
		card_state = CARD_STATES.DECK
		
	elif type == CARD_STATES.HAND:
		var angle = PI/2 + CARD_SPREAD*(float(hand.size() - 1)/2 - card_num)
		var oval_angle_vector = Vector2(hor_rad * cos(angle), - ver_rad * sin(angle))
		
		in_hand_pos = center_card_oval + oval_angle_vector - Vector2(125,175)
		in_hand_angle = (90 - rad2deg(angle))/4
		
		move(DRAW_TIME, in_hand_pos, in_hand_angle, Vector2(1, 1))
		card_state = CARD_STATES.HAND
		
	elif type == CARD_STATES.DISCARD and card_state != CARD_STATES.DISCARD:
		move(DISCARD_TIME, discard_sprite.position - rect_size * discard_sprite.scale / 2, 0, discard_sprite.scale)
		card_state = CARD_STATES.DISCARD
		
	elif type == CARD_STATES.SLOTS:
		# retrieve currently selected slot
		var slot_node = get_node("../../LetterSlots") 
		
		target_pos = slot_node.get_child(in_slot).rect_position # cover slot
		target_scale = slot_node.get_child(in_slot).rect_scale
		target_rot = 0
		
		move(ORGANIZE_TIME, target_pos, target_rot, target_scale)	
		card_state = CARD_STATES.SLOTS
	
	elif type == CARD_STATES.PLAYED and card_state != CARD_STATES.PLAYED:
		var scale = Vector2(0.1, 0.1)
		move(PLAY_TIME, self.target_pos, 0, scale)
		card_state = CARD_STATES.PLAYED
	
