extends Node

@export var upgrade_screen_scene: PackedScene 
@export var experience_manager: Node

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_mov_speed = preload("res://resources/upgrades/mov_speed_upgrade.tres")
var upgrade_axe_ability = preload("res://resources/upgrades/axe_ability.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_anvil_ability = preload("res://resources/upgrades/anvil_ability.tres")
var upgrade_more_anvils = preload("res://resources/upgrades/more_anvils.tres")


func _ready():
#	upgrade_pool.add_item(upgrade_mov_speed.name, upgrade_mov_speed, 10)
#	upgrade_pool.add_item(upgrade_axe_ability.name, upgrade_axe_ability, 15)
#	upgrade_pool.add_item(upgrade_axe_damage.name, upgrade_axe_damage, 0)
#	upgrade_pool.add_item(upgrade_sword_rate.name, upgrade_sword_rate, 30)
#	upgrade_pool.add_item(upgrade_sword_damage.name, upgrade_sword_damage, 30)
	upgrade_pool.add_item(upgrade_anvil_ability.name, upgrade_anvil_ability, 15)
	upgrade_pool.add_item(upgrade_more_anvils.name, upgrade_more_anvils, 0)
	
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
	var chosen_upgrades_array: Array[AbilityUpgrade] = pick_upgrades()
	
	if(chosen_upgrades_array.size() == 0):
		return
	
	show_upgrade_screen(chosen_upgrades_array)


func pick_upgrades():
	var chosen_upgrades_array: Array[AbilityUpgrade] = []
	var item_weights = []
	
	for i in 2:
		var rand_upgrade = upgrade_pool.choose_item() as AbilityUpgrade 
		if(rand_upgrade == null):
			continue
		item_weights.append(upgrade_pool.get_item_weight(rand_upgrade.name))
		chosen_upgrades_array.append(rand_upgrade)
		upgrade_pool.change_item_weight(rand_upgrade.name, 0)
	
	var count = 0
	for upgrade in chosen_upgrades_array:
		upgrade_pool.change_item_weight(upgrade.name, item_weights[count])
		count += 1
	
	return chosen_upgrades_array


func show_upgrade_screen(upgrade_array: Array[AbilityUpgrade]):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	
	upgrade_screen_instance.set_ability_upgrades(upgrade_array)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_select)


func on_upgrade_select(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if(!has_upgrade):
		#Adds new upgrade by its id if it hasnt been seen yet
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		#Otherwise increases the amount of times we have seen the upgrade
		current_upgrades[upgrade.id]["quantity"] += 1
	
	var current_quantity = current_upgrades[upgrade.id]["quantity"]
	
	if(current_quantity >= upgrade.max_quantity and upgrade.max_quantity != 0):
		upgrade_pool.change_item_weight(upgrade.name, 0)
		
		if(upgrade.name == "Axe Ability"):
			upgrade_pool.change_item_weight("Axe Damage", 15)
		
		if(upgrade.name == "Anvil ability"):
			upgrade_pool.change_item_weight("More anvils", 10)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


