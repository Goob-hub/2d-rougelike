extends Node2D

@export var max_range: float = 150
@export var sword_ability: PackedScene 
@export var minimum_sword_rate: float = .5
@export var damage = 5

var sword_rate

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	sword_rate = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if(upgrade.id != "sword_rate" or sword_rate == minimum_sword_rate):
		return
	
	var upgrade_quantity = current_upgrades["sword_rate"]["quantity"]
	var percent_reduction = (sword_rate * .1) * upgrade_quantity
	var new_sword_rate = maxf(minimum_sword_rate, (sword_rate - percent_reduction))
	
	sword_rate = new_sword_rate
	$Timer.wait_time = new_sword_rate
	#Will restart timer and reset the wait time
	$Timer.start()


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
	sword_instance.hitbox_component.damage = damage
	
	set_sword_position(sword_instance, closest_enemy)


func set_sword_position(sword_instance: SwordAbility, closest_enemy: CharacterBody2D):
	#This Adds a 4 pixel offset to the sword instance spawn. TAU is 2PI since this is in radians
	#Basically this is rotating the sword based on 360 deg in radians and offsetting *4
	sword_instance.global_position = closest_enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = (closest_enemy.global_position - sword_instance.global_position)
	sword_instance.rotation = enemy_direction.angle()
