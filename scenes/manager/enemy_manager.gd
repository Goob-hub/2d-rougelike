extends Node2D

const SPAWN_RADIUS: int = 370
const MINIMUM_TIMER_WAIT_TIME: float = .4

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item("basic_enemy", basic_enemy_scene, 100)
	
	arena_time_manager.arena_difficulty_increased.connect(on_difficulty_increased)
	$Timer.timeout.connect(on_timer_timeout)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(player == null):
		return Vector2.ZERO
	
	#Get's random point in rotation around a circle 
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = Vector2.ZERO
	
	for i in 4:
		#From the players global position, move out the distance of spawn radius in specified direction to spawn enemies
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		#Creates parameters for a ray cast to be instantiated. Takes origin, end position, and bitmask to look for collision on
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		
		#Get main scene window in 2d and look for potential collisions using line between 2 points (Ray cast)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		#The ray will return empty {} if there are no collisions READ DOCUMENTATION
		if(result.is_empty()):
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	$Timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(player == null):
		return
	
	var rand_enemy_scene = enemy_table.choose_item()
	var enemy = rand_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	
	enemy.global_position = get_spawn_position()
	
#	Grab global difficulty modifier and change enemies health multipliers depending on difficulty
#	enemy.health_component.health_multiplier = .5
#	enemy.health_component.update_health_values()


func on_difficulty_increased(current_difficulty: int):
	if(current_difficulty == 6):
		enemy_table.add_item("wizard_enemy", wizard_enemy_scene, 10)
	elif(current_difficulty > 8):
		for enemy in enemy_table.items:
			if(enemy["name"] == "wizard_enemy"):
				enemy["weight"] += 1
	
	var new_wait_time = maxf($Timer.wait_time - (.1 / 12 * current_difficulty), MINIMUM_TIMER_WAIT_TIME)
	$Timer.wait_time = new_wait_time
