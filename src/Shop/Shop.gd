extends Node2D

var gold = 105

func _ready():
	randomize();
	$Gold.text = gold as String

func _on_BuyButton1_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$BuyButton1.count += 1
		if $BuyButton1.count < 3:
			$BuyButton1.price *= 2
			$BuyButton1.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton1.text = "Sold out"

func _on_BuyButton2_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$BuyButton2.count += 1
		if $BuyButton2.count < 3:
			$BuyButton2.price *= 2
			$BuyButton2.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton2.text = "Sold out"
				
	$Gold.text = gold as String

func _on_BuyButton3_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		set_gold(gold - price)
		$BuyButton3.count += 1
		if $BuyButton3.count < 3:
			$BuyButton3.price *= 2
			$BuyButton3.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton3.text = "Sold out"

# Updates player's gold
func set_gold(gold):
	self.gold = gold
	$Gold.text = gold as String
