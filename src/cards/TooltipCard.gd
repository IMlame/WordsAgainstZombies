extends MarginContainer

const KEYWORD_DATA = preload("res://assets/cards/KeywordDatabase.gd").DATA

signal press_detected(card_data)

var tooltip := ""
var hover := false
var tooltip_timer = 0

func _ready():
	$PopupPanel._set_position(get_position() + Vector2(get_size().x,0))
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
	$PopupPanel._set_position(get_global_position() + Vector2(get_size().x,0))
	$PopupPanel/Label.set_size(Vector2($PopupPanel.get_size().x - 10,$PopupPanel/Label.get_line_count() * $PopupPanel/Label.get_line_height() + 20))
	$PopupPanel.set_size($PopupPanel/Label.get_size() + Vector2(10,20))

func set_border_color(color: Color):
	$ReferenceRect.set_border_color(color)

func _on_Detect_mouse_entered():
	hover = true

func _on_Detect_mouse_exited():
	hover = false

func _on_Detect_pressed():
	var card_data = CardData.new()
	card_data.name = $CardBase.name
	card_data.damage = $CardBase.damage
	card_data.effects = $CardBase.effects
	card_data.word_count = $CardBase.word_count
	card_data.draw_count = $CardBase.draw_count
	emit_signal("press_detected", card_data)
