extends Node2D

@export var enemy_to_spawn: PackedScene

@onready var particles = $GPUParticles2D

func spawn_enemy():
	var enemy_instance = enemy_to_spawn.instantiate()
	var entity_layer = get_tree().get_first_node_in_group("entities_layer")
	entity_layer.add_child(enemy_instance)
	enemy_instance.global_position = self.global_position


func turn_particles_on():
	particles.emitting = true
