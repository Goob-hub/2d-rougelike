extends CharacterBody2D

@onready var visuals_layer = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent
@export var entity_spawned_after_death: PackedScene
@export var entity_amount: int = 0

var ability_list = {}

func _ready():
	ability_list.death_ability = {
		"entity": entity_spawned_after_death,
		"entity_amount": entity_amount
	} 
	$HurtBoxComponent.hit.connect(on_hit)

func _process(delta):
	velocity_component.get_direction_to_player()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	visuals_layer.scale = velocity_component.face_towards_player()


func on_hit():
	$RandomHitSoundComponent.play_random_sound()
