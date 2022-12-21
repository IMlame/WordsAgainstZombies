extends Node

var _save: GameData

const CardDataClass = preload("res://src/global/CardData.gd")

var player_info: Resource
var dungeon_info: Resource

var chosen_save = -1

func _ready():
	_save = GameData.new()
	var default_deck = ["N", "T", "L", "Y", "H", "L", "J", "E", "L","P","U","D","K","Q","E","B","G","F","I","J","A","I","O"]
	for letter in default_deck:
		var card_data = CardData.new()
		card_data.load_default(letter)
		_save.player_info.deck.append(card_data)

func save_data():
	# saves data to last loaded save
	if chosen_save != -1:
		_save.write_savegame(chosen_save)
		print("data saved to slot " + str(chosen_save))
	else:
		print("error: no save chosen")

func load_data(save_num: int):
	chosen_save = save_num
	# load save file based on parameter number
	if save_num >= 0 and save_num < 4:
		# save file number that's loaded (future save method calls will save to this file)
		if GameData.save_exists(chosen_save):
			_save = GameData.load_savegame(chosen_save)
			player_info = _save.player_info
			dungeon_info = _save.dungeon_info
			return true
	return false
