extends Node2D

const TOOLTIP_CARD = preload("res://src/cards/TooltipCard.tscn")
const POOL = preload("res://assets/pools/TempShopPool.gd") 
var gold = 105
var price_scalar = 2
var starting_price = 5
var num_card = 3
onready var buttons = get_tree().get_nodes_in_group("BuyButtons")

func _ready():
	randomize();
	$Gold.set_text(gold as String)
	set_starting_price(starting_price)
	
	# Initialize cards
	for i in range(3):
		var selected_card = POOL.CARDLIST[randi() % POOL.SIZE]
		var card_data = CardData.new()
		card_data.load_default(selected_card)
		for j in range(num_card):
			var card = TOOLTIP_CARD.instance()
			card.set_card_data(card_data)
			$Cards.get_child(i).add_child(card)
			if j < 2:
				card.set_process(false)
			card.set_scale(Vector2(1,1))
			card.set_position(Vector2(i * (card.get_child(0).get_node("Card").texture.get_size().x + 260) + 140, 
									300 + card.get_node("CardBase/Card/Bar/TopBar").rect_size.y * j))
	# Update position for Buttons
	$BuyButton1.set_position($Cards/Slot1.get_child(num_card - 1).get_position() + Vector2(0,$Cards/Slot1.get_child(num_card - 1).get_size().y + 100))
	$BuyButton2.set_position($Cards/Slot2.get_child(num_card - 1).get_position() + Vector2(0,$Cards/Slot2.get_child(num_card - 1).get_size().y + 100))
	$BuyButton3.set_position($Cards/Slot3.get_child(num_card - 1).get_position() + Vector2(0,$Cards/Slot3.get_child(num_card - 1).get_size().y + 100))

# Update Player's gold based on price of the card
func _on_BuyButton1_my_price(price):
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$Cards/Slot1.get_child(num_card - 1 - $BuyButton1.count).queue_free() # remove card
		$BuyButton1.count += 1
		if $BuyButton1.count < $BuyButton1.MAX_COUNT:
			$Cards/Slot1.get_child(num_card - 1 - $BuyButton1.count).set_process(true)
			$BuyButton1.scale_price(price_scalar)
			$BuyButton1.set_text("Buy " + $BuyButton1.price as String)
		else:
			$BuyButton1.set_text("Sold out")

# Update Player's gold based on price of the card
func _on_BuyButton2_my_price(price):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$Cards/Slot2.get_child(num_card - 1 - $BuyButton2.count).queue_free() # remove card
		$BuyButton2.count += 1
		if $BuyButton2.count < $BuyButton2.MAX_COUNT:
			$Cards/Slot2.get_child(num_card - 1 - $BuyButton2.count).set_process(true)
			$BuyButton2.scale_price(price_scalar)
			$BuyButton2.set_text("Buy " + $BuyButton2.price as String)
		else:
			$BuyButton2.set_text("Sold out")

# Update Player's gold based on price of the card
func _on_BuyButton3_my_price(price):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$Cards/Slot3.get_child(num_card - 1 - $BuyButton3.count).queue_free() # remove card
		$BuyButton3.count += 1
		if $BuyButton3.count < $BuyButton3.MAX_COUNT:
			$Cards/Slot3.get_child(num_card - 1 - $BuyButton3.count).set_process(true)
			$BuyButton3.scale_price(price_scalar)
			$BuyButton3.set_text("Buy " + $BuyButton3.price as String)
		else:
			$BuyButton3.set_text("Sold out")

# Set player's gold
func set_gold(gold: int):
	self.gold = gold
	$Gold.set_text(gold as String)

# Set starting price of the shop
func set_starting_price(price: int):
	starting_price = price
	for button in buttons:
		button.set_starting_price(price)

# Update price scalar of the shop
func set_price_scalar(scalar: int):
	price_scalar = scalar
