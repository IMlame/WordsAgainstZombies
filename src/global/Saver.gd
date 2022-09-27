extends Node

const SAVE_DIR = "user://saves/"

const CardDataClass = preload("res://src/global/CardData.gd")

var chosen_save = -1

# list of variables important to keep track of in our game
var character_class = "evan"
var cur_health = 50
var max_health = 100
var gold = 0
var xp = 0
var xp_level = 0
var stage = 0
var base_damage = 0
var starting_hand_count = 0
var letter_count = 4
var deck = []

func _ready():
	# test card to be saved
	var default_deck = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
	for letter in default_deck:
		var card_data = CardData.new()
		card_data.load_default(letter)
		deck.append(card_data)

func save_data():
	# saves data to last loaded save
	if chosen_save != -1:
		
		# json object that weilds all game info
		var game_data = {
			"character_class" : character_class,
			"cur_health" : cur_health,
			"max_health" : max_health,
			"gold" : gold,
			"xp" : xp,
			"xp_level" : xp_level,
			"stage" : stage,
			"base_damage" : base_damage,
			"starting_hand_count" : starting_hand_count,
			"letter_count" : letter_count,
			"deck" : deck
		}
		
		# creates directories if directories don't exist
		# saved in user data -> saves -> save_(num).txt
		var dir = Directory.new()
		if !dir.dir_exists(SAVE_DIR):
			dir.make_dir_recursive(SAVE_DIR)
			
		var file = File.new()
		var error = file.open(SAVE_DIR + "save_" + str(chosen_save) + ".txt", File.WRITE)
		if error == OK:
			# store json file in text file
			file.store_line(JSON.print(game_data, "  "))
			file.close()
		
		print("data saved to save_" + str(chosen_save) + ".txt")
	else:
		print("error: no save chosen")
	
func load_data(save_num: int):
	# load save file based on parameter number
	if save_num >= 0 and save_num < 4:
		# save file number that's loaded (future save method calls will save to this file)
		chosen_save = save_num
		var file = File.new()
		if file.file_exists(SAVE_DIR + "save_" + str(chosen_save) + ".txt"):
			var error = file.open(SAVE_DIR + "save_" + str(chosen_save) + ".txt", File.READ)
			if error == OK:
				var game_data = JSON.parse(file.get_as_text()).result
				file.close()
				# set this class' variables to data from json object
				character_class = game_data.get("character_class")
				cur_health = game_data.get("cur_health")
				max_health = game_data.get("max_health")
				gold = game_data.get("gold")
				xp = game_data.get("xp")
				xp_level = game_data.get("xp_level")
				stage = game_data.get("stage")
				base_damage = game_data.get("base_damage")
				starting_hand_count = game_data.get("starting_hand_count")
				letter_count = game_data.get("letter_count")
				deck = game_data.get("deck")
				
				return true
	return false
