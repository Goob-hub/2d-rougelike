extends Node

signal arena_difficulty_increased(current_difficulty: int)


@onready var timer = $Timer
@export var end_screen_scene: PackedScene

var difficulty_interval = 5
var arena_difficulty = 0
var current_difficulty 

func _ready():
	timer.timeout.connect(on_timer_timeout)
	current_difficulty = MetaProgression.get_current_difficulty()
	
	#Depending on the global difficulty, make the enemies spawn faster sooner
	if(current_difficulty == "easy"):
		difficulty_interval = 5
	
	if(current_difficulty == "normal"):
		difficulty_interval = 3
		arena_difficulty = 4
	
	if(current_difficulty == "hard"):
		difficulty_interval = 1
		arena_difficulty = 8


func _process(delta):
	var target_interval = timer.wait_time - ((arena_difficulty + 1) * difficulty_interval)
	if(timer.time_left <= target_interval):
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	GameEvents.emit_game_over()
	var end_screen = end_screen_scene.instantiate()
	end_screen.play_victory_animation()
	add_child(end_screen)
