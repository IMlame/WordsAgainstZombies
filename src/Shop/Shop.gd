extends Node2D

const CARDBASE = preload("res://src/Battle/Cards/CardBase.tscn")
const POOL = preload("res://assets/Pools/TempShopPool.gd") 
var gold = 105
var price_scalar = 2
var starting_price = 5
onready var buttons = get_tree().get_nodes_in_group("BuyButtons")

func _ready():
	randomize();
	$Gold.text = gold as String
	set_starting_price(starting_price)
	
#	var card = CARDBASE.instance()
#	card.Cardname = POOL.CARDLIST[randi() % POOL.SIZE]
#	card.rect_position = Vector2(500,500)
#	$Cards.get_child(0).add_child(card)
#	print($Cards.get_child(0).get_child(0).rect_position)
	
	# Initialize cards
#	for i in range(3):
#		for j in range(3):
#			var card = CARDBASE.instance()
#			card.Cardname = POOL.CARDLIST[randi() % POOL.SIZE]
#			card.rect_position = Vector2(i * 400 + 200, 200 + 200 * j)
#			$Cards.get_child(i).add_child(card)

func _on_BuyButton1_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$BuyButton1.count += 1
		if $BuyButton1.count < $BuyButton1.MAX_COUNT:
			$BuyButton1.scale_price(price_scalar)
			$BuyButton1.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton1.text = "Sold out"

func _on_BuyButton2_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$BuyButton2.count += 1
		if $BuyButton2.count < $BuyButton2.MAX_COUNT:
			$BuyButton2.scale_price(price_scalar)
			$BuyButton2.text = "Buy " + $BuyButton2.price as String
		else:
			$BuyButton2.text = "Sold out"
				
	$Gold.text = gold as String

func _on_BuyButton3_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$BuyButton3.count += 1
		if $BuyButton3.count < $BuyButton3.MAX_COUNT:
			$BuyButton3.scale_price(price_scalar)
			$BuyButton3.text = "Buy " + $BuyButton3.price as String
		else:
			$BuyButton3.text = "Sold out"

# Set player's gold
func set_gold(gold: int):
	self.gold = gold
	$Gold.text = gold as String

# Set starting price of the shop
func set_starting_price(price: int):
	starting_price = price
	for button in buttons:
		button.set_starting_price(price)

# Update price scalar of the shop
func set_price_scalar(scalar: int):
	price_scalar = scalar
