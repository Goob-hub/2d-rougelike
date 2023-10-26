extends Node

@export var axe_ability_scene: PackedScene

var damage = 10

func _ready():
	$Timer.timeout.connect(on_timer_timeout)

#ADD upgrade where two axes spawn going in opposite directions Vector2.left and Vector2.right
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	
	if(player == null or foreground == null):
		return
	
	var axe_ability = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_ability)
	axe_ability.global_position = player.global_position
	axe_ability.hitbox_component.damage = damage
