extends Reference

class_name CardData

const DEFAULT = preload("res://assets/Cards/CardDatabase.gd").DATA
var letter = null
var damage = 0
var draw_count = 0
var word_count = 0
var effects = null
var keywords = null

enum {
	LETTER,
	DAMAGE,
	DRAW_COUNT,
	WORD_COUNT,
	EFFECTS,
	KEYWORDS
}

func _init(letter = null, damage = 0, draw_count = 0, word_count = 0, effects = null, keywords = null):
	self.letter = letter
	self.damage = damage
	self.draw_count = draw_count
	self.word_count = word_count
	self.effects = ["potato", "owo"]
	self.keywords = keywords

func load_default(letter):
	self.letter = letter
	self.damage = DEFAULT[letter][0]
	self.draw_count = DEFAULT[letter][1]
	self.word_count = DEFAULT[letter][2]
	self.effects = DEFAULT[letter][3]
	self.keywords = DEFAULT[letter][4]

func _to_string():
	return str({"damage": damage, "draw_count": draw_count, "word_count": word_count, "effects": effects, "keywords": keywords})
