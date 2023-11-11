extends StaticBody2D

@export var speed = 150
@export var damage = 1

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer


var direction

func _ready():
#	$RandomSoundPlayerComponent.play_random_sound()
	global_position -= Vector2(47, 42)
	timer.timeout.connect(on_timer_timeout)
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()


func _process(delta):
	global_position += (direction * speed * delta)


func on_timer_timeout():
	queue_free()
