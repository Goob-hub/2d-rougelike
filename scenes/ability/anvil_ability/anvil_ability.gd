extends Node2D
class_name AnvilAbility

@onready var hitbox_component = $HitBoxComponent
@onready var impact_particles = $GPUParticles2D

func enable_hitbox():
	hitbox_component.get_children()[0].disabled = false


func disable_hitbox():
	hitbox_component.get_children()[0].disabled = true


func emit_particles():
	impact_particles.emitting = true
