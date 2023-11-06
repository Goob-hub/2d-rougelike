extends Node

const ANVIL_RATE = 3

@export var max_range: float = 180
@export var anvil_ability: PackedScene 
@export var damage: float = 5
@export var max_anvils_spawned = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	$Timer.wait_time = ANVIL_RATE
	$Timer.timeout.connect(on_timer_timeout)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if(upgrade.id == "more_anvils"):
		max_anvils_spawned = current_upgrades["more_anvils"]["quantity"] + 1


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	
	if(player == null):
		return
	
	var enemies = get_enemies_in_range(player)
	
	if(enemies.size() == 0):
		return
	
	var closest_enemies = getClosestEnemies(enemies, player)
	
	spawn_anvil_on_enemies(closest_enemies)


func get_enemies_in_range(player: CharacterBody2D):
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	enemies = enemies.filter(func(enemy: CharacterBody2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)
	
	return enemies


func getClosestEnemies(enemies_list: Array, player: CharacterBody2D):
	enemies_list.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	return enemies_list


func spawn_anvil_on_enemies(closest_enemies: Array):
	var anvils_spawned = 0
	var previous_enemy = null
	
	while anvils_spawned < max_anvils_spawned:
		var anvil_instance = anvil_ability.instantiate() as AnvilAbility
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		
		foreground_layer.add_child(anvil_instance)
		anvil_instance.hitbox_component.damage = damage
		
		if(anvils_spawned < closest_enemies.size()):
			var current_enemy = closest_enemies[anvils_spawned]
			previous_enemy = current_enemy
			anvil_instance.global_position = current_enemy.global_position
		else:
			anvil_instance.global_position = previous_enemy.global_position
		
		anvils_spawned += 1
