extends Node

@export var attack: PackedScene
@export var time_between_attacks: float = 2

signal is_attacking

var ready_to_attack = true

func _ready():
	$Timer.wait_time = time_between_attacks
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	ready_to_attack = true


func use_attack(position: Vector2):
	if(ready_to_attack):
		is_attacking.emit()
		var atk = attack.instantiate() as Node2D
		owner.get_tree().get_first_node_in_group("projectiles").add_child(atk)
		atk.global_position = position
		ready_to_attack = false
		$Timer.start()
