extends Reference

class_name CardData

var name = null
var damage = 0
var draw_count = 0
var word_count = 0
var attributes = null
var keywords = null

enum {
	NAME,
	DAMAGE,
	DRAW_COUNT,
	WORD_COUNT,
	ATTRIBUTES,
	KEYWORDS
}

func _init(name = null, damage = 0, draw_count = 0, word_count = 0, attributes = ["potato", "owo"], 
			keywords = null):
	self.name = name
	self.damage = damage
	self.draw_count = draw_count
	self.word_count = word_count
	self.attributes = attributes
	self.keywords = keywords

func _to_string():
	return str({"name": name, "damage": damage, "draw_count": draw_count, "word_count": word_count, 
				"attributes": attributes, "keywords": keywords})
