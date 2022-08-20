extends Node

var character_class = null
var cur_health = 0
var max_health = 0
var deck = []
var gold = 0
var xp = 0
var xp_level = 0
var stage = 0
var base_damage = 0
var starting_hand_count = 0
var letter_count = 0

func _ready():
	print("dab")

func save_data():
	var game_data = {
		"character_class" : character_class,
		"cur_health" : cur_health,
		"max_health" : max_health,
		"deck" : deck,
		"gold" : gold,
		"xp" : xp,
		"xp_level" : xp_level,
		"stage" : stage,
		"base_damage" : base_damage,
		"starting_hand_count" : starting_hand_count,
		"letter_count" : letter_count
	}
