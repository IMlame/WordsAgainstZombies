extends Button

var count: int = 0		# Keeping track of buy count
var price: int = 5		# Starting price

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_BuyButton_pressed():
	# If bought less than 3 times then return price, else return 0 as null
	if count < 3:
		emit_signal("pressed", price)
	else:
		emit_signal("pressed", 0)
