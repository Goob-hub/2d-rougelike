extends Node

@export var mov_speed: int = 40
@export var acceleration: float = 5

var direction
var velocity = Vector2.ZERO


func get_direction_to_player():
	var owner_node_2d = owner as Node2D
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(owner_node_2d == null or player == null):
		return
	
	direction = (player.global_position - owner_node_2d.global_position).normalized()


func accelerate_to_player():
	var target_velocity = direction * mov_speed
	#Gradually gets to target velocity based on the percent provided
	velocity = velocity.lerp(target_velocity, 1 - exp(-get_process_delta_time() * acceleration))


func face_towards_player():
	if(direction.x < 0):
		return Vector2(-1, 1)
	elif(direction.x > 0 or direction.x == 0):
		return Vector2(1, 1)


func move(character_body: Node2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	#Re-setting the velocity here in the script because move and slide alters the character velocity
	velocity = character_body.velocity


