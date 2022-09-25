extends MarginContainer

# Card Data
var card_data = CardData.new()

func set_card_data(card_data: CardData):
	self.card_data = card_data
	
	$Card/Bar/TopBar/Damage/HBoxContainer/Damage.set_text(card_data.damage as String)
	$Card/Bar/MidBar/CardName/HBoxContainer/CardName.set_text(card_data.name)
	$Card/Bar/MidBar2/Description/CenterContainer/Description.set_text(card_data.effects)
	$Card/Bar/BotBar/Word/HBoxContainer/Word.set_text(card_data.word_count as String)
	$Card/Bar/BotBar/Draw/HBoxContainer/Draw.set_text(card_data.draw_count as String)
