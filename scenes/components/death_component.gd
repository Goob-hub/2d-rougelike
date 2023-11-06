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
	
	var parent_abilities = get_parent().ability_list
	var enemy_position = get_parent().global_position
	var entity_layer = get_tree().get_first_node_in_group("entities_layer")
	var projectile_layer = get_tree().get_first_node_in_group("projectiles")
	get_parent().remove_child(self)
	
	entity_layer.add_child(self)
	self.global_position = enemy_position
	animation_player.play("default")
	$RandomHitSoundComponent.play_random_sound()
	
	if(parent_abilities.has("death_ability")):
		var death_ability = parent_abilities.death_ability 
		var entitys_spawned = 0
		print(death_ability)
		while entitys_spawned < death_ability.entity_amount:
			var entity_spawn_instance = death_ability.entity.instantiate()
			
			if(death_ability.is_projectile == true):
				projectile_layer.add_child(entity_spawn_instance)
			else:
				entity_layer.add_child(entity_spawn_instance)
			
			if(death_ability.randomize_spawn_position == false):
				entity_spawn_instance.global_position = enemy_position
			else:
				entity_spawn_instance.global_position = enemy_position + Vector2(randi_range(10, 20), randi_range(10, 20))
			
			entitys_spawned += 1

