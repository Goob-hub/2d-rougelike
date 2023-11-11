extends Node
class_name HealthComponent

signal dead
signal damaged
signal healed(heal_amount)

@export var max_health: float
var current_health: float
var health_multiplier = 1

var is_dead_signal_emitted = false
var enemy_manager

func _ready():
	enemy_manager = get_parent().get_tree().get_first_node_in_group("enemy_manager")
	var global_difficulty = MetaProgression.get_current_difficulty()
	current_health = max_health * health_multiplier
	
	if(owner.is_in_group("enemy")):
		if(global_difficulty == "easy"):
			health_multiplier = 1
			update_health_values()
		
		if(global_difficulty == "normal"):
			health_multiplier = 1.5
			update_health_values()
		
		if(global_difficulty == "hard"):
			health_multiplier = 2
			update_health_values()


func update_health_values():
	max_health *= health_multiplier
	current_health = max_health


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	Callable(check_death).call_deferred()
	
	if(current_health == 0):
		return
	damaged.emit()


func get_health_percent():
	if(current_health <= 0):
		return
	return current_health / max_health


func check_death():
	if(current_health == 0 && not is_dead_signal_emitted):
		dead.emit()
		is_dead_signal_emitted = true
		if(owner.name == "Player"):
			return
		
		enemy_manager.enemy_count -= 1
		
		owner.queue_free()


func heal(heal_amount: float):
	if(heal_amount == null):
		return
	
	current_health += heal_amount
	
	if(current_health >= max_health):
		current_health = max_health
		return
	
	healed.emit(heal_amount)
