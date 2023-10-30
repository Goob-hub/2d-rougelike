extends Node2D

@export var experience_gained: float = 5
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Visuals/Sprite2D

func _ready():
	animation_player.play("idle")
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	#This Will call the function without the relation to the parent function, avoiding an error
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	
	
	#Call func with binded value. Func called in delta time over .75s
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .75)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	
	tween.parallel().tween_property(sprite, "scale", Vector2(1.2, 1.2), .75)
	
	tween.tween_callback(collect_vial)
	
	$RandomExpSound.play_random_sound()


func tween_collect(percent: float, start_pos: Vector2):
	animation_player.stop()
	
	var player = get_tree().get_first_node_in_group("player")
	if(player == null):
		return
	
	#Use lerp to get the vial to go from start to player over the specified time(percent)
	global_position = start_pos.lerp(player.global_position, percent)
	
	var direction = player.global_position - global_position
	#Calculating rotation to lerp to using degrees
	var target_rotation = direction.angle() + rad_to_deg(270)
	#Rotating to specified angle overtime
	rotation = lerp_angle(rotation, -target_rotation, 1 - exp(-2 * get_process_delta_time()))


func disable_collision():
	collision_shape_2d.disabled = true


func collect_vial():
	GameEvents.emit_experience_vial_collected(experience_gained)
	queue_free()
