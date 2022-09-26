extends Sprite

const EFFECT_TYPES = EffectEnum.EFFECT_TYPES
const IMAGE_WIDTH = 150

# effects on enemy applied by enemy
var active_effects = []


func _ready():
	texture = load("res://assets/Characters/character_art/" + Saver.character_class + "_60x60.png")
	scale = Vector2(IMAGE_WIDTH/get_rect().size.x, IMAGE_WIDTH/get_rect().size.x)
	$Healthbar.max_value = Saver.max_health
	$Healthbar.value = Saver.cur_health
	$Healthbar.rect_scale = Vector2(1/scale.x, 1/scale.y)
	$Healthbar.set_position(Vector2((get_rect().size.x - $Healthbar.get_rect().size.x * (1/scale.x)) / 2 , get_rect().size.y + 25))
	
	for i in range(EFFECT_TYPES.size()): # fill active_effects with 0's
		active_effects.append(0)
		
	for indicator in $Indicators.get_children():
		indicator.scale = Vector2(1/scale.x * 0.8, 1/scale.y * 0.8)
		indicator.position = Vector2(position.x + 
		int(indicator.get_name()) * 
		(indicator.texture.get_width() * indicator.scale.x + (IMAGE_WIDTH - 4 * indicator.scale.x * indicator.texture.get_width()) / 3), 
		position.y - indicator.texture.get_height() * indicator.scale.y)

	
	
func apply_effect(effect: int):
	if effect < EFFECT_TYPES.size():	# apply one stack of effect
		active_effects[effect] += 1
	_update_indicators()

func damage(damage_amount: int):
	$Healthbar.value -= damage_amount

func attack(enemy: Sprite, dmg: int, effects: Array):
	var attack = true
	var attack_multiplier = 1
	
	if active_effects[EFFECT_TYPES.FREEZE] > 0:	# skip turn if paralyze is applied
		active_effects[EFFECT_TYPES.FREEZE] -= 1
		attack = false
	else:
		if active_effects[EFFECT_TYPES.PARALYZE] > 0: # skip attack if freeze is applied
			active_effects[EFFECT_TYPES.PARALYZE] -= 1
			attack = false
		
		if active_effects[EFFECT_TYPES.BURN] > 0:
			damage(10 * active_effects[EFFECT_TYPES.BURN]) # arbitrary burn damage
			active_effects[EFFECT_TYPES.BURN] -= 1

		if active_effects[EFFECT_TYPES.WEAKNESS]:
			attack_multiplier -= 0.1 * active_effects[EFFECT_TYPES.WEAKNESS] # weakness
			active_effects[EFFECT_TYPES.WEAKNESS] -= 1
	
	if attack:
		enemy.damage(dmg * attack_multiplier)
		for effect in effects:
			enemy.apply_effect(effect)
	
	_update_indicators()
	
func _update_indicators():
	for indicator in $Indicators.get_children():
		var effect = int(indicator.get_name())
		indicator.get_child(0).text = str(active_effects[effect])
		if active_effects[effect] > 0:
			indicator.modulate = Color(1, 1, 1, 1)
		else:
			indicator.modulate = Color(0, 0, 0, 1)

