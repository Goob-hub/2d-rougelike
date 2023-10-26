extends CharacterBody2D

@export var mov_speed: float = 75
@export var acceleration: float = 15
@export var player_hurt_box: Area2D
@export var player_health_component: HealthComponent
@export var hurt_delay_timer: Timer

@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals_layer = $Visuals

var enemies_hurting_player = 0


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	player_hurt_box.body_entered.connect(on_body_entered)
	player_hurt_box.body_exited.connect(on_body_exited)
	
	hurt_delay_timer.timeout.connect(on_timer_timeout)


func _process(delta):
	var mov_vector = get_mov_vector()
	var direction = mov_vector.normalized()
	var target_velocity = direction * mov_speed 
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * acceleration))
	move_and_slide()
	
	if(mov_vector.x != 0 or mov_vector.y != 0):
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	if(direction.x < 0):
		visuals_layer.scale = Vector2(mov_vector.x, 1)
	elif(direction.x > 0):
		visuals_layer.scale = Vector2(mov_vector.x, 1)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if(not upgrade is Ability):
		return
	
	if(current_upgrades.has("axe_ability") and upgrade.id != "axe_ability"):
		return
	
	var axe_ability_scene = upgrade.ability_controller_scene.instantiate()
	abilities.add_child(axe_ability_scene)


func get_mov_vector():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	return Vector2(x_mov, y_mov)


func check_for_damage():
	if(enemies_hurting_player <= 0 or !hurt_delay_timer.is_stopped()):
		return
	
	if(player_health_component == null):
		print("No health component assigned.")
		return
	
	player_health_component.damage(1 * enemies_hurting_player)
	hurt_delay_timer.start()


func on_body_entered(other_body: Node2D):
	enemies_hurting_player += 1
	check_for_damage()
	if(other_body.get_parent().name == "Projectiles"):
		other_body.queue_free()


func on_body_exited(other_body: Node2D):
	enemies_hurting_player -= 1


func on_timer_timeout():
	check_for_damage()
