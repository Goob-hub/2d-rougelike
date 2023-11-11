extends Node

signal regenerate_health(regen_amount)

@export var regen_interval:float = 1
@export var regen_amount:float = 0

@onready var timer = $Timer


func _ready():
	timer.wait_time = regen_interval
	timer.timeout.connect(on_timer_timeout)


func set_new_interval(interval: float):
	timer.wait_time = interval


func on_timer_timeout():
	regenerate_health.emit(regen_amount)
