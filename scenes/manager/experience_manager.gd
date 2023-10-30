extends Node

signal experience_updated(current_experience: float, target_expreince: float)
signal level_up(new_level: int)

@export var target_expreience_growth = 1

var current_level = 1
var current_experience = 0
var target_expreince = 1


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func on_experience_vial_collected(number: float):
	increment_experience(number)


func increment_experience(number: float):
	current_experience = min(current_experience + number, target_expreince)
	
	if(current_experience == target_expreince):
		current_experience = 0
		current_level += 1
		target_expreince += target_expreience_growth
		level_up.emit(current_level)
	
	experience_updated.emit(current_experience, target_expreince)
