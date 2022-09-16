extends Node

const SAVE_DIR = "user://saves/"

const CardDataClass = preload("res://src/global/CardData.gd")

var chosen_save = -1

var character_class = null
var cur_health = 0
var max_health = 0
var gold = 0
var xp = 0
var xp_level = 0
var stage = 0
var base_damage = 0
var starting_hand_count = 0
var letter_count = 0
var deck = null
var letter_info = {}

func _ready():
	var card = CardDataClass.new("a", 1, 2, 3, [])
	letter_info[card.name] = card

func save_data():
	if chosen_save != -1:
		var json_letter_info = {}
		# convert letter info to json array
		for key in letter_info:
			json_letter_info[key] = {
				"attributes" : letter_info[key].attributes,
				"damage" : letter_info[key].damage,
				"draw_count" : letter_info[key].draw_count,
				"word_count": letter_info[key].word_count}
		
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
			"deck" : deck,
			"letter_info" : json_letter_info
		}
		
		var dir = Directory.new()
		if !dir.dir_exists(SAVE_DIR):
			dir.make_dir_recursive(SAVE_DIR)
			
		var file = File.new()
		var error = file.open(SAVE_DIR + "save_" + str(chosen_save) + ".txt", File.WRITE)
		if error == OK:
			file.store_line(JSON.print(game_data, "  "))
			file.close()
		
		print("data saved to save_" + str(chosen_save) + ".txt")
	else:
		print("error: no chose chosen")
	
func load_data(save_num: int):
	if save_num >= 0 and save_num < 4:
		chosen_save = save_num
		var file = File.new()
		if file.file_exists(SAVE_DIR + "save_" + str(chosen_save) + ".txt"):
			var error = file.open(SAVE_DIR + "save_" + str(chosen_save) + ".txt", File.READ)
			if error == OK:
				var game_data = JSON.parse(file.get_as_text()).result
				file.close()
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
				
				for key in game_data.get("letter_info").keys():
					var letter = game_data.get("letter_info").get(key)
					letter_info[key] = CardDataClass.new(key, letter.get("damage"), letter.get("draw_count"), letter.get("word_count"), letter.get("attributes"))
				return true
	return false
