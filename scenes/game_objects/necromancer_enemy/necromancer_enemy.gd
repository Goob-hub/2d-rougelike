extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var attack_component = $AttackComponent
@onready var visuals_layer = $Visuals
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Visuals/Sprite2D
@onready var health_component = $HealthComponent
@onready var particles = $GPUParticles2D

@export var max_range: float
@export var run_away_range: float 

var ability_list = {}
var is_attacking = false

func _ready():
	max_range = pow(max_range, 2)
	run_away_range = pow(run_away_range, 2)
	
	$HurtBoxComponent.hit.connect(on_hit)


func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if(player == null):
		return
	
	var distance_from_player_squared = global_position.distance_squared_to(player.global_position)
	
	velocity_component.get_direction_to_player()
	
	if(attack_component.ready_to_attack and distance_from_player_squared <= max_range):
		attack()
	
	if(is_attacking == true):
		visuals_layer.scale = velocity_component.face_towards_player()
		return
	
	if(distance_from_player_squared > run_away_range and distance_from_player_squared < max_range):
		animation_player.stop()
	
	#If player is within percent of standing range, start running away
	if(distance_from_player_squared < run_away_range):
		var direction_opposite_of_player = (self.global_position - player.global_position).normalized()
		visuals_layer.scale = velocity_component.face_away_from_player()
		velocity_component.accelerate_in_direction(direction_opposite_of_player)
		velocity_component.move(self)
		animation_player.play("walk")
		return
	
	if(distance_from_player_squared > max_range):
		visuals_layer.scale = velocity_component.face_towards_player()
		velocity_component.accelerate_to_player()
		velocity_component.move(self)
		animation_player.play("walk")


func attack():
	is_attacking = true
	animation_player.stop()
	animation_player.play("RESET")
	animation_player.play("attack")
	attack_component.use_attack(get_random_position())


func get_random_position():
	#Get's random point in rotation around a circle 
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = Vector2.ZERO
	
	for i in 4:
		#From the enemy global position, move out the distance of spawn radius in specified direction to spawn enemies
		spawn_position = self.global_position + (random_direction * randi_range(10, 30))
		var additional_offset = random_direction * 20
		
		#Creates parameters for a ray cast to be instantiated. Takes origin, end position, and bitmask to look for collision on
		var query_parameters = PhysicsRayQueryParameters2D.create(self.global_position, spawn_position + additional_offset, 1 << 0)
		
		#Get main scene window in 2d and look for potential collisions using line between 2 points (Ray cast)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		#The ray will return empty {} if there are no collisions READ DOCUMENTATION
		if(result.is_empty()):
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func stop_attacking():
	is_attacking = false


func emit_particles():
	particles.emitting = true


func on_hit():
	$RandomHitSoundComponent.play_random_sound()
