extends CharacterBody2D

@onready var visuals_layer = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent
@onready var block_ability_component = $BlockAbilityComponent

var ability_list = {}

func _ready():
	$HurtBoxComponent.hit.connect(on_hit)
	ability_list.block_ability = block_ability_component


func _process(delta):
	velocity_component.get_direction_to_player()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	visuals_layer.scale = velocity_component.face_towards_player()


func on_hit():
	$RandomHitSoundComponent.play_random_sound()


func stop_moving():
	velocity_component.mov_speed = 0
	velocity_component.acceleration = 100


func start_moving():
	velocity_component.mov_speed = 60
	velocity_component.acceleration = 5
