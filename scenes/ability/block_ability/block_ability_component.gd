extends Node

@export var block_image: Texture
@export var block_chance_percent:float = 0
@export var parent_entity: CharacterBody2D

@onready var random_sound_player_component = $RandomSoundPlayerComponent

var floating_image = preload("res://scenes/ui/floating_image.tscn")


func _ready():
	if(get_parent().get_parent().name == "Player"):
		var meta_block_upgrade = MetaProgression.get_meta_upgrade("block_ability")
		
		if(meta_block_upgrade != null):
			block_chance_percent += meta_block_upgrade.value_percent * meta_block_upgrade.quantity


func check_if_blocked():
	var rand_float = randf_range(0, 1)
	if(rand_float < block_chance_percent):
		show_block_vfx()
		return true
	
	return false


func show_block_vfx():
	if(parent_entity == null):
		return
	
	var floating_image_instance = floating_image.instantiate()
	floating_image_instance.image_to_display = block_image
	parent_entity.add_child(floating_image_instance)
	
	floating_image_instance.global_position = parent_entity.global_position + Vector2(10, -10)
	random_sound_player_component.play_random_sound()
