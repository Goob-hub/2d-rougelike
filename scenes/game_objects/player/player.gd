extends CharacterBody2D

@export var player_hurt_box: Area2D
@export var player_health_component: HealthComponent
@export var hurt_delay_timer: Timer

@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals_layer = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hit_sound_component = $RandomHitSoundComponent
@onready var block_ability_component = $Abilities/BlockAbilityComponent
@onready var health_regeneration_ability = $Abilities/HealthRegenerationAbility

var enemies_hurting_player = 0
var mov_speed_multiplier = 1
var floating_text = preload("res://scenes/ui/floating_text.tscn")


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	player_hurt_box.body_entered.connect(on_body_entered)
	player_hurt_box.body_exited.connect(on_body_exited)
	player_health_component.healed.connect(on_heal)
	
	hurt_delay_timer.timeout.connect(on_timer_timeout)
	
	var health_upgrade = MetaProgression.get_meta_upgrade("player_health")
	var regen_ability = MetaProgression.get_meta_upgrade("regeneration_ability")
	
	if(health_upgrade != null):
		player_health_component.health_multiplier += health_upgrade.quantity * health_upgrade.value_percent
		player_health_component.update_health_values()
	
	if(regen_ability != null):
		health_regeneration_ability.set_new_interval(10 - regen_ability.quantity)
		health_regeneration_ability.regen_amount = 1
		health_regeneration_ability.regenerate_health.connect(on_health_regen)

func _process(delta):
	var mov_vector = get_mov_vector()
	var direction = mov_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	check_for_damage()
	
	if(mov_vector.x != 0 or mov_vector.y != 0):
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	if(direction.x < 0):
		visuals_layer.scale = Vector2(mov_vector.x, 1)
	elif(direction.x > 0):
		visuals_layer.scale = Vector2(mov_vector.x, 1)
	
	if(enemies_hurting_player < 0):
		enemies_hurting_player = 0


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if(upgrade.id == "mov_speed"):
		mov_speed_multiplier += upgrade.value_percent
		velocity_component.acceleration += 3
		velocity_component.mov_speed = velocity_component.mov_speed * mov_speed_multiplier
	
	if(upgrade.id == "axe_ability"):
		var axe_ability_instance = upgrade.ability_controller_scene.instantiate()
		abilities.add_child(axe_ability_instance)
	
	if(upgrade.id == "anvil_ability"):
		var anvil_ability_instance = upgrade.ability_controller_scene.instantiate()
		abilities.add_child(anvil_ability_instance)
	
	if(upgrade.id == "block_ability"):
		block_ability_component.block_chance_percent += upgrade.value_percent


func get_mov_vector():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	return Vector2(x_mov, y_mov)


func check_for_damage():
	if(enemies_hurting_player == 0 or not hurt_delay_timer.is_stopped()):
		return
	
	if(player_health_component == null):
		print("No health component assigned.")
		return
	
	damage_player(1 * enemies_hurting_player)


func damage_player(damage: float):
	var is_attack_blocked = block_ability_component.check_if_blocked()
	
	if(is_attack_blocked == true):
		is_attack_blocked = false
		return
	
	var dmg_txt = floating_text.instantiate()
	
	dmg_txt.damage_done = damage
	dmg_txt.global_position += self.global_position
	
	owner.get_tree().get_first_node_in_group("foreground_layer").add_child(dmg_txt)
	
	player_health_component.damage(damage)
	GameEvents.emit_player_damaged()
	hit_sound_component.play_random_sound()
	hurt_delay_timer.start()


func on_body_entered(other_body: Node2D):
	if(other_body.is_in_group("enemy_projectile")):
		other_body.queue_free()
		damage_player(other_body.damage)
	else:
		enemies_hurting_player += 1


func on_body_exited(other_body: Node2D):
	enemies_hurting_player -= 1


func on_timer_timeout():
	check_for_damage()


func on_health_regen(heal_amount: float):
	player_health_component.heal(heal_amount)


func on_heal(heal_amount):
	var text = floating_text.instantiate()
	
	text.amount_healed = heal_amount
	text.global_position += self.global_position
	
	owner.get_tree().get_first_node_in_group("foreground_layer").add_child(text)
