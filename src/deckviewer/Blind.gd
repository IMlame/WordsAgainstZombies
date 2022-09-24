extends TextureButton

# Delete this scene when you click spot with blank space

func _ready():
	set_size(get_viewport().get_size())												# Set size of blind
	$BigCard.set_scale(Vector2(1,1) * get_size().y / $BigCard.get_size().y)			# Set size of card
	$BigCard.set_position(Vector2((get_size().x - $BigCard.get_size().x * $BigCard.get_scale().x)/2,0))	# Set position of Poup
	$BigCard/PopupPanel.set_scale($BigCard.get_scale() - Vector2(1,1))				# Set size of Popup
	$BigCard.set_process(false)														# Turn off hover for panel

# Set card data of enlarged card
func set_card_data(card_data):
	$BigCard.set_card_data(card_data)
	if card_data.keywords != []:				# Display popup when card has keyword
		$BigCard/PopupPanel.visible = true

# Delete this scene when user clicks other than card or panel
func _on_Blind_pressed():
	queue_free()
