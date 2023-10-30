extends Node2D

@export var max_range: float = 150
@export var sword_ability: PackedScene 
@export var damage: float = 5
@export var damage_multiplier: float = 1

var sword_rate = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	$Timer.wait_time = sword_rate
	$Timer.timeout.connect(on_timer_timeout)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if(upgrade.id == "sword_rate"):
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * upgrade.value_percent
		var new_sword_rate = sword_rate * (1 - percent_reduction)
		$Timer.wait_time = new_sword_rate
		#Will restart timer and reset the wait time
		$Timer.start()
	elif(upgrade.id == "sword_damage"):
		damage_multiplier += upgrade.value_percent
	
	


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	
	if(player == null):
		return
	
	var enemies = get_enemies_in_range(player)
	
	if(enemies.size() == 0):
		return
	
	var closest_enemy = getClosestEnemy(enemies, player) as CharacterBody2D
	
	instantiate_sword_in_scene(closest_enemy)


func get_enemies_in_range(player: CharacterBody2D):
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	enemies = enemies.filter(func(enemy: CharacterBody2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)
	
	return enemies


func getClosestEnemy(enemies_list: Array, player: CharacterBody2D):
	enemies_list.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	return enemies_list[0]


func instantiate_sword_in_scene(closest_enemy: CharacterBody2D):
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage * damage_multiplier
	
	set_sword_position(sword_instance, closest_enemy)


func set_sword_position(sword_instance: SwordAbility, closest_enemy: CharacterBody2D):
	#This Adds a 4 pixel offset to the sword instance spawn. TAU is 2PI since this is in radians
	#Basically this is rotating the sword based on 360 deg in radians and offsetting *4
	sword_instance.global_position = closest_enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = (closest_enemy.global_position - sword_instance.global_position)
	sword_instance.rotation = enemy_direction.angle()
