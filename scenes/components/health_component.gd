extends Node
class_name HealthComponent

signal dead
signal damaged

@export var max_health: float
var current_health: float
var health_multiplier = 1

var is_dead_signal_emitted = false

func _ready():
	current_health = max_health * health_multiplier


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
		owner.queue_free()
