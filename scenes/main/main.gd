extends Node2D

@export var end_screen_scene: PackedScene

func _ready():
	$%Player.get_children()[0].dead.connect(on_player_death)
	


func on_player_death():
	GameEvents.is_player_dead = true
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
