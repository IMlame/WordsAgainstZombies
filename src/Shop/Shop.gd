extends Node2D

const CARDBASE = preload("res://src/Battle/Cards/CardBase.tscn")
const POOL = preload("res://assets/Pools/TempShopPool.gd") 
var gold = 105
var price_scalar = 2
var starting_price = 5
var num_card = 3
onready var buttons = get_tree().get_nodes_in_group("BuyButtons")

func _ready():
	randomize();
	$Gold.text = gold as String
	set_starting_price(starting_price)
	
	# Initialize cards
	for i in range(3):
		var selected_card = POOL.CARDLIST[randi() % POOL.SIZE]
		for j in range(num_card):
			var card = CARDBASE.instance()
			card.Cardname = selected_card
			$Cards.get_child(i).add_child(card)
			card.rect_scale = Vector2(1,1)
			card.rect_position = Vector2(i * (card.get_node("Card").texture.get_size().x + 150) + 200, 
									200 + card.get_node("Card/Bar/TopBar").rect_size.y * j)

# Update Player's gold based on price of the card
func _on_BuyButton1_my_price(price):
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$Cards/Slot1.get_child(num_card - 1 - $BuyButton1.count).queue_free() # remove card
		$BuyButton1.count += 1
		if $BuyButton1.count < $BuyButton1.MAX_COUNT:
			$BuyButton1.scale_price(price_scalar)
			$BuyButton1.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton1.text = "Sold out"
				
	$Gold.text = gold as String

# Update Player's gold based on price of the card
func _on_BuyButton2_my_price(price):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$Cards/Slot2.get_child(num_card - 1 - $BuyButton2.count).queue_free() # remove card
		$BuyButton2.count += 1
		if $BuyButton2.count < $BuyButton2.MAX_COUNT:
			$BuyButton2.scale_price(price_scalar)
			$BuyButton2.text = "Buy " + $BuyButton2.price as String
		else:
			$BuyButton2.text = "Sold out"
				
	$Gold.text = gold as String

# Update Player's gold based on price of the card
func _on_BuyButton3_my_price(price):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$Cards/Slot3.get_child(num_card - 1 - $BuyButton3.count).queue_free() # remove card
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




