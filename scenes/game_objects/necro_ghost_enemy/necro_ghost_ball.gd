extends StaticBody2D

@export var speed = 150
@export var damage = 1

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer


var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))

func _ready():
#	$RandomSoundPlayerComponent.play_random_sound()
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	global_position += (direction * speed * delta)


func on_timer_timeout():
	queue_free()
