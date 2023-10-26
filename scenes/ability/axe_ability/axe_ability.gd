extends Node2D

const RADIUS_GROWTH = 200
const MAX_RADIUS = 50

@onready var hitbox_component = $HitBoxComponent

var base_rotation = Vector2.RIGHT

func _ready():
	#Randomizes the start position of axe ability around the player
	base_rotation = Vector2.RIGHT.rotated(randf() * TAU)
	
	var tween = create_tween()
	#Define as floats if you want the tween to go through decimal. example values: (0.0, 5.5)
	tween.tween_method(tween_function, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)
	


#The circle the axe is moving around the player is constantly growing for the 2 seconds of the animation
func tween_function(rotations: float):
	#How far percentage wise are we through the animation
	var percent = rotations / 2
	var current_radius = minf(percent * RADIUS_GROWTH, MAX_RADIUS)
	var cur_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player") 
	
	if(player == null):
		return
	
	var root_position = player.global_position
	global_position = root_position + (cur_direction * current_radius)
