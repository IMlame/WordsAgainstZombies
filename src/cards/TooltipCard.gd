extends MarginContainer

const KEYWORD_DATA = preload("res://assets/cards/KeywordDatabase.gd").DATA

var tooltip := ""
var hover := false
var tooltip_timer = 0

func _ready():
	$PopupPanel.set_position(get_position() + Vector2(get_size().x,0))
	$PopupPanel.set_custom_minimum_size(Vector2(100,50))
	$PopupPanel/Label.set_text(tooltip)

func _process(delta):
	if hover:
		tooltip_timer += delta
		if tooltip_timer >= 0.5:
			update_panel()
			$PopupPanel.visible = true
	else:
		tooltip_timer = 0
		$PopupPanel.visible = false

func set_card_data(card_data: CardData):
	$CardBase.set_card_data(card_data)
	for keyword in card_data.keywords:
		tooltip += keyword + "\n"
		tooltip += KEYWORD_DATA[keyword][0]
	update_panel()
		
func update_panel():
	$PopupPanel/Label.set_size(Vector2($PopupPanel.get_size().x - 10,$PopupPanel/Label.get_line_count() * $PopupPanel/Label.get_line_height() + 20))
	$PopupPanel.set_size($PopupPanel/Label.get_size() + Vector2(10,20))

func _on_HoverDetect_mouse_entered():
	hover = true

func _on_HoverDetect_mouse_exited():
	hover = false
