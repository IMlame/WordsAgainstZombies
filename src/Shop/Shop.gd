extends Node2D

var gold = 50	

func _ready():
	randomize();
	$Gold.text = gold as String

# Sets up player's gold
func set_gold(gold):
	self.gold = gold
	$Gold.text = gold as String

func _on_BuyButton1_pressed():
	match $BuyButton1.count:
		0:
			if gold >= 5:
				gold -= 5
				$BuyButton1.count += 1
				$BuyButton1.text = "Buy 10"
		1:
			if gold >= 10:
				gold -= 10
				$BuyButton1.count += 1
				$BuyButton1.text = "Buy 20"
		2:
			if gold >= 20:
				gold -= 20
				$BuyButton1.count += 1
				$BuyButton1.text = "Sold out"
				
	$Gold.text = gold as String

func _on_BuyButton2_pressed():
	match $BuyButton2.count:
		0:
			if gold >= 5:
				gold -= 5
				$BuyButton2.count += 1
				$BuyButton2.text = "Buy 10"
		1:
			if gold >= 10:
				gold -= 10
				$BuyButton2.count += 1
				$BuyButton2.text = "Buy 20"
		2:
			if gold >= 20:
				gold -= 20
				$BuyButton2.count += 1
				$BuyButton2.text = "Sold out"
				
	$Gold.text = gold as String


func _on_BuyButton3_pressed():
	match $BuyButton3.count:
		0:
			if gold >= 5:
				gold -= 5
				$BuyButton3.count += 1
				$BuyButton3.text = "Buy 10"
		1:
			if gold >= 10:
				gold -= 10
				$BuyButton3.count += 1
				$BuyButton3.text = "Buy 20"
		2:
			if gold >= 20:
				gold -= 20
				$BuyButton3.count += 1
				$BuyButton3.text = "Sold out"

	$Gold.text = gold as String
