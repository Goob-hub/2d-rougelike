extends Node2D

const SPAWN_RADIUS: int = 370
const MINIMUM_TIMER_WAIT_TIME: float = .3

@onready var timer = $Timer
@export var arena_time_manager: Node

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var tank_enemy_scene: PackedScene
@export var spider_enemy_scene: PackedScene
@export var necromancer_enemy_scene: PackedScene

var enemy_table = WeightedTable.new()
var global_difficulty

#Tracks whether or not enemy weight has been changed from 0 to it's base weight
var wizard_weight_changed = false
var bat_weight_changed = false
var tank_weight_changed = false
var spider_weight_changed = false
var necromancer_weight_changed = false

func _ready():
	global_difficulty = MetaProgression.get_current_difficulty()

	enemy_table.add_item("basic_enemy", basic_enemy_scene, 120)
	enemy_table.add_item("bat_enemy", bat_enemy_scene, 0)
	enemy_table.add_item("wizard_enemy", wizard_enemy_scene, 0)
	enemy_table.add_item("tank_enemy", tank_enemy_scene, 0)
	enemy_table.add_item("spider_enemy", spider_enemy_scene, 0)
	enemy_table.add_item("necromancer_enemy", necromancer_enemy_scene, 0)
	arena_time_manager.arena_difficulty_increased.connect(on_difficulty_increased)
	timer.timeout.connect(on_timer_timeout)


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
		var additional_offset = random_direction * 20
		
		#Creates parameters for a ray cast to be instantiated. Takes origin, end position, and bitmask to look for collision on
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_offset, 1 << 0)
		
		#Get main scene window in 2d and look for potential collisions using line between 2 points (Ray cast)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		#The ray will return empty {} if there are no collisions READ DOCUMENTATION
		if(result.is_empty()):
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(player == null):
		return
	
	var rand_enemy_scene = enemy_table.choose_item()
	if(rand_enemy_scene == null):
		return
	
	var enemy = rand_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	
	enemy.global_position = get_spawn_position()


func on_difficulty_increased(arena_difficulty: int):
	if(arena_difficulty > 6 and bat_weight_changed == false):
		enemy_table.change_item_weight("bat_enemy", 55)
		bat_weight_changed = true
	
	if(arena_difficulty > 12 and tank_weight_changed == false):
		enemy_table.change_item_weight("tank_enemy", 35)
		tank_weight_changed = true
	
	if(arena_difficulty > 16 and wizard_weight_changed == false):
		enemy_table.change_item_weight("wizard_enemy", 10)
		wizard_weight_changed = true
	
	if(arena_difficulty == 16):
		enemy_table.change_item_weight("basic_enemy", 100)
	
	if(arena_difficulty > 20 and spider_weight_changed == false):
		enemy_table.change_item_weight("spider_enemy", 25)
		spider_weight_changed = true
	
	if(arena_difficulty > 24 and necromancer_weight_changed == false):
		enemy_table.change_item_weight("necromancer_enemy", 10)
		necromancer_weight_changed = true
#	if(arena_difficulty > 20 and arena_difficulty < 35):
#		for enemy in enemy_table.items:
#			if(enemy["name"] == "wizard_enemy" and enemy["weight"] < 15):
#				enemy["weight"] += 1
	
	if(timer.wait_time > .3):
		var new_wait_time = maxf(timer.wait_time - (.1 / 12 * arena_difficulty), MINIMUM_TIMER_WAIT_TIME)
		timer.wait_time = new_wait_time
