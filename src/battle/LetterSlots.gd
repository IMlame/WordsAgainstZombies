extends Node


# slots
const CARDSLOT = preload("res://src/battle/CardSlot.tscn")
const SPACING = 175
const X_PERCENT = 55
var selected_slot = -1


func _ready():
	# setup slots
	for i in range(0, Saver.letter_count):
		var slot = CARDSLOT.instance()
		slot.set_scale(Vector2(0.6, 0.6))
		slot.set_position(Vector2(Sizer.percent_width(50) - ((Saver.letter_count - 1) * SPACING / 2) + SPACING * i, Sizer.percent_height(X_PERCENT)))
		slot.connect("slot_hovered", self, "_on_slot_hovered")
		slot.connect("slot_unhovered", self, "_on_slot_unhovered")
		slot.connect("slot_change", self, "_on_slot_change")
		add_child(slot)
		
func _on_slot_hovered(slot_num: int):
	selected_slot = slot_num
	
func _on_slot_unhovered():
	selected_slot = -1

func _on_slot_change(hand_count_diff: int):
	pass

