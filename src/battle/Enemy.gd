extends Sprite

const ENEMY_TYPES = EnemyEnum.ENEMY_TYPES

const EFFECT_TYPES = EffectEnum.EFFECT_TYPES

var rng = RandomNumberGenerator.new()
# effects and percentages of hitting
var on_hit_effects = {EFFECT_TYPES.FREEZE: 0, EFFECT_TYPES.BURN: 0, EFFECT_TYPES.WEAKNESS: 0, EFFECT_TYPES.PARALYZE: 0, EFFECT_TYPES.HEAL: 0}
var base_damage = 0

# effects on enemy applied by player (index > 0 represents 1 stack of an effect)
var active_effects = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	scale = Vector2(150/get_rect().size.x, 150/get_rect().size.x)
	
	for i in range(EFFECT_TYPES.size()): # fill active_effects with 0's
		active_effects.append(0)
	
func setup_enemy(type: int, max_health: int, base_damage: int, on_hit_effects: Dictionary):
	self.base_damage = base_damage
	texture = load("res://assets/enemies/" + str(type) + ".png")
	scale = Vector2(150/get_rect().size.x, 150/get_rect().size.x)
	$Healthbar.rect_scale = Vector2(1/scale.x, 1/scale.y)
	$Healthbar.set_position(Vector2((get_rect().size.x - $Healthbar.get_rect().size.x * (1/scale.x)) / 2, get_rect().size.y + 25))
	$Healthbar.max_value = max_health
	$Healthbar.value = max_health
	
	for effect in on_hit_effects.keys():
		if effect >= 0 and effect <= EFFECT_TYPES.size():
			self.on_hit_effects[effect] = on_hit_effects[effect]


func apply_effect(effect: int):
	if effect < EFFECT_TYPES.size():	# apply one stack of effect
		active_effects[effect] += 1

func damage(damage_amount: int):
	$Healthbar.value -= damage_amount

func attack(player: Sprite):
	var attack = true
	var attack_multiplier = 1
	
	if active_effects[EFFECT_TYPES.FREEZE] > 0:	# skip turn if freeze is applied
		active_effects[EFFECT_TYPES.FREEZE] -= 1
		attack = false
	else:
		if active_effects[EFFECT_TYPES.PARALYZE] > 0: # skip attack if paralyze is applied
			active_effects[EFFECT_TYPES.PARALYZE] -= 1
			attack = false
		
		if active_effects[EFFECT_TYPES.BURN] > 0:
			damage(10 * active_effects[EFFECT_TYPES.BURN]) # arbitrary burn damage
			active_effects[EFFECT_TYPES.BURN] -= 1

		if active_effects[EFFECT_TYPES.WEAKNESS]:
			attack_multiplier -= 0.1 * active_effects[EFFECT_TYPES.WEAKNESS] # weakness
			active_effects[EFFECT_TYPES.WEAKNESS] -= 1
			
	if attack:
		player.damage(self.base_damage)	# damage player
		for effect in on_hit_effects.keys():	# apply effects (randomizer for variability)
			if rng.randi_range(0, 100) <= on_hit_effects[effect]:
				player.apply_effect(effect)
		
	
