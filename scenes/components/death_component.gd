extends Node2D

@export var health_component: HealthComponent
@export var texture: CompressedTexture2D
@export var blood_animation: ParticleProcessMaterial
@export var body_animation: ParticleProcessMaterial

@onready var animation_player = $AnimationPlayer
@onready var body_particles = $BodyParticles
@onready var blood_particles = $BloodParticles


func _ready():
	health_component.dead.connect(on_dead)
	body_particles.texture = texture
	
	body_particles.process_material = body_animation
	blood_particles.process_material = blood_animation


func on_dead():
	if get_parent() == null or not get_parent() is Node2D:
		return
	
	var enemy_position = get_parent().global_position
	var entity_layer = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	
	entity_layer.add_child(self)
	self.global_position = enemy_position
	animation_player.play("default")
