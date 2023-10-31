extends Node2D

@export var end_screen_scene: PackedScene
var pause_menu = preload("res://scenes/ui/pause_menu.tscn")

func _ready():
	$%Player.get_children()[0].dead.connect(on_player_death)


func _process(delta):
	if(Input.get_action_strength("Pause") == 1 and !get_tree().paused):
		var pause_instance = pause_menu.instantiate()
		add_child(pause_instance)
		get_tree().paused = true


func on_player_death():
	GameEvents.is_player_dead = true
	GameEvents.emit_game_over()
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
