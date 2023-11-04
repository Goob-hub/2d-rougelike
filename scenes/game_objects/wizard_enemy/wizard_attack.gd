extends StaticBody2D

@export var speed = 200
@export var damage = 2

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer


var direction = null

func _ready():
	$RandomSoundPlayerComponent.play_random_sound()
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(player == null):
		return
	
	if(direction == null):
		direction = (player.global_position - self.global_position).normalized()
	
	global_position += (direction * speed * delta)


func on_timer_timeout():
	queue_free()
