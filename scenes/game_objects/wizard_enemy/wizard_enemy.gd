extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var attack_component = $AttackComponent
@onready var visuals_layer = $Visuals
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Visuals/Sprite2D
@onready var staff_sprite = $Visuals/StaffSprite
@onready var health_component = $HealthComponent

@export var attack_range: float = 100


var is_reset = true
var ability_list = {}

func _ready():
	attack_component.is_attacking.connect(on_attack)
	$HurtBoxComponent.hit.connect(on_hit)


func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if(player == null):
		return
	
	var distance_from_player_squared = global_position.distance_squared_to(player.global_position)
	
	velocity_component.get_direction_to_player()
	visuals_layer.scale = velocity_component.face_towards_player()
	
	if(distance_from_player_squared < pow(attack_range, 2)):
		if(is_reset == false):
			reset_sprites()
		
		if(attack_component.ready_to_attack):
			reset_sprites()
			$AttackWarningPlayer.play("before_attack")
			await $AttackWarningPlayer.animation_finished
			attack_component.use_attack(self.global_position)
	else:
		is_reset = false
		animation_player.play("walking")
		velocity_component.accelerate_to_player()
		velocity_component.move(self)


func reset_sprites():
	animation_player.stop()
	sprite_2d.rotation = 0
	staff_sprite.rotation = 0
	staff_sprite.position.y = -6
	is_reset = true


func on_attack():
	animation_player.play("attack")


func on_hit():
	$RandomHitSoundComponent.play_random_sound()
