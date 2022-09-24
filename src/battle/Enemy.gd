extends Sprite

enum ENEMY_TYPES {BASIC, SHIELD, BROILER, COOL, AXOLOTL, FRIDGE}

enum EFFECT_TYPES {FREEZE, BURN, WEAKNESS, PARALYZE, HEAL}

var enemy = ENEMY_TYPES.BASIC

var effects = {EFFECT_TYPES.FREEZE: 0, EFFECT_TYPES.BURN: 0, EFFECT_TYPES.WEAKNESS: 0, EFFECT_TYPES.PARALYZE: 0, EFFECT_TYPES.HEAL: 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _setup_enemy(type: int, max_health: int, base_damage: int, effects: Array, immunities: Array):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
