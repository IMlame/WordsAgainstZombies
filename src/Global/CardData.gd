extends Reference

class_name CardData

var letter = null
var damage = 0
var draw_count = 0
var word_count = 0
var attributes = null

enum {
	LETTER,
	DAMAGE,
	DRAW_COUNT,
	WORD_COUNT,
	ATTRIBUTES
}

func _init(letter = null, damage = 0, draw_count = 0, word_count = 0, attributes = null):
	self.letter = letter
	self.damage = damage
	self.draw_count = draw_count
	self.word_count = word_count
	self.attributes = ["potato", "owo"]

func _to_string():
	return str({"damage": damage, "draw_count": draw_count, "word_count": word_count, "attributes": attributes})
