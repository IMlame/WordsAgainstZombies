extends Button

signal my_price(price)

var count: int = 0			# Keeping track of buy count
var price: int = 5			# Starting price
const MAX_COUNT: int = 3	# Maximum buy count

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Buy " + price as String
	
func _on_BuyButton_pressed():
	# If bought less than 3 times then return price, else return 0 as null
	if count < MAX_COUNT:
		emit_signal("my_price", price)
	else:
		emit_signal("my_price", 0)

func scale_price(scalar: int):
	price *= scalar
	
func set_starting_price(new_price: int):
	price = new_price
	text = "Buy " + price as String
	
