extends Node

signal arena_difficulty_increased(current_difficulty: int)

const DIFFICULTY_INTERVAL = 5

@onready var timer = $Timer
@export var end_screen_scene: PackedScene

var arena_difficulty = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	var target_interval = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
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
