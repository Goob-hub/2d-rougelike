extends Node
class_name HealthComponent

signal dead
signal damaged

@export var max_health: float = 10
var current_health: float


func _ready():
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
	if(current_health == 0):
		dead.emit()
		owner.queue_free()