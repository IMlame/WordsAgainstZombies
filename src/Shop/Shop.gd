extends Node2D

var gold = 105

func _ready():
	randomize();
	$Gold.text = gold as String

# Sets up player's gold
func set_gold(gold):
	self.gold = gold
	$Gold.text = gold as String

#func _on_BuyButton1_pressed():
#	match $BuyButton1.count:
#		0:
#			if gold >= 5:
#				gold -= 5
#				$BuyButton1.count += 1
#				$BuyButton1.text = "Buy 10"
#		1:
#			if gold >= 10:
#				gold -= 10
#				$BuyButton1.count += 1
#				$BuyButton1.text = "Buy 20"
#		2:
#			if gold >= 20:
#				gold -= 20
#				$BuyButton1.count += 1
#				$BuyButton1.text = "Sold out"
#
#	$Gold.text = gold as String

func _on_BuyButton1_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		gold -= price
		$Gold.text = gold as String
		$BuyButton1.count += 1
		if $BuyButton1.count < 3:
			$BuyButton1.price *= 2
			$BuyButton1.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton1.text = "Sold out"

func _on_BuyButton2_pressed(price: int):
	# If price isn't null (0), then buy card and update the gold
	if price > 0 and gold >= price:
		gold -= price
		$Gold.text = gold as String
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
		gold -= price
		$Gold.text = gold as String
		$BuyButton3.count += 1
		if $BuyButton3.count < 3:
			$BuyButton3.price *= 2
			$BuyButton3.text = "Buy " + $BuyButton1.price as String
		else:
			$BuyButton3.text = "Sold out"


