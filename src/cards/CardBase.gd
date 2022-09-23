extends MarginContainer

# Card Data
var card_name = 'A'
var damage 
var word_count
var draw_count
var effects
var keywords

func set_hint(hint: String):
	hint_tooltip = hint

func set_card_data(card_data: CardData):
	damage = card_data.damage
	card_name = card_data.name
	effects = card_data.effects
	word_count = card_data.word_count
	draw_count = card_data.draw_count
	
	$Card/Bar/TopBar/Damage/HBoxContainer/Damage.set_text(damage as String)
	$Card/Bar/MidBar/CardName/HBoxContainer/CardName.set_text(card_name)
	$Card/Bar/MidBar2/Description/CenterContainer/Description.set_text(effects)
	$Card/Bar/BotBar/Word/HBoxContainer/Word.set_text(word_count as String)
	$Card/Bar/BotBar/Draw/HBoxContainer/Draw.set_text(draw_count as String)
	print(card_data)
