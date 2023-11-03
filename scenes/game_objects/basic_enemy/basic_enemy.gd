extends CharacterBody2D

@onready var visuals_layer = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent


func _ready():
	$HurtBoxComponent.hit.connect(on_hit)

func _process(delta):
	velocity_component.get_direction_to_player()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	visuals_layer.scale = velocity_component.face_towards_player()


func on_hit():
	$RandomHitSoundComponent.play_random_sound()

