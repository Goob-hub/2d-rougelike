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


var enemies_hurting_player = 0
var mov_speed_multiplier = 1


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	player_hurt_box.body_entered.connect(on_body_entered)
	player_hurt_box.body_exited.connect(on_body_exited)
	
	hurt_delay_timer.timeout.connect(on_timer_timeout)
	
	var health_upgrade = MetaProgression.get_meta_upgrade("player_health")
	if(health_upgrade != null):
		player_health_component.health_multiplier += health_upgrade.quantity * health_upgrade.value_percent
		player_health_component.update_health_values()


func _process(delta):
	var mov_vector = get_mov_vector()
	var direction = mov_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if(mov_vector.x != 0 or mov_vector.y != 0):
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	if(direction.x < 0):
		visuals_layer.scale = Vector2(mov_vector.x, 1)
	elif(direction.x > 0):
		visuals_layer.scale = Vector2(mov_vector.x, 1)


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


func get_mov_vector():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	return Vector2(x_mov, y_mov)


func check_for_damage():
	if(enemies_hurting_player <= 0 or not hurt_delay_timer.is_stopped()):
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
	
	player_health_component.damage(1 * enemies_hurting_player)
	GameEvents.emit_player_damaged()
	hit_sound_component.play_random_sound()
	hurt_delay_timer.start()


func on_body_entered(other_body: Node2D):
	enemies_hurting_player += 1
	check_for_damage()
	if(other_body.get_parent().name == "Projectiles"):
		damage_player(1)
		other_body.queue_free()


func on_body_exited(other_body: Node2D):
	enemies_hurting_player -= 1


func on_timer_timeout():
	check_for_damage()

