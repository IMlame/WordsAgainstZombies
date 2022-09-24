extends Sprite

enum ENEMY_TYPE {NORMAL, AXOLOTL, BULLY, FRIDGE}

var enemy = ENEMY_TYPE.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _setup_enemy(enemy: int, max_health: int, base_damage: int, effects: Array, immunities: Array):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
