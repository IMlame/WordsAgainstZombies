extends Reference

class_name CardData

const DEFAULT = preload("res://assets/cards/CardDatabase.gd").DATA
var name = ""
var damage = 0
var draw_count = 0
var word_count = 0
var effects = ""
var keywords = []

enum {
	NAME,
	DAMAGE,
	DRAW_COUNT,
	WORD_COUNT,
	EFFECTS,
	KEYWORDS
}

func _init(name = "A", damage = 1, draw_count = 0, word_count = 2, effects = "", keywords = []):
	self.name = name
	self.damage = damage
	self.draw_count = draw_count
	self.word_count = word_count
	self.effects = effects
	self.keywords = keywords

func load_default(name):
	self.name = name
	self.damage = DEFAULT[name][0]
	self.draw_count = DEFAULT[name][1]
	self.word_count = DEFAULT[name][2]
	self.effects = DEFAULT[name][3]
	self.keywords = DEFAULT[name][4]

func _to_string():
	return str({"name": name, "damage": damage, "draw_count": draw_count, "word_count": word_count, 
				"effects": effects, "keywords": keywords})

static func sort_name_ascending(a: CardData,b: CardData):
	if a.name.length == 1 and b.name.length == 1:
		return a.name <= b.name
	elif a.name.length == 1 and b.name.length != 1:
		return true
	elif a.name.length != 1 and b.name.length == 1:
		return false
	else:
		if a.name == "Wild":
			return true
		elif a.name == "Health" and b.name != "Wild":
			return true
		elif a.name == "Word" and b.name != "Wild" and b.name != "Health":
			return true
		else:
			return false
