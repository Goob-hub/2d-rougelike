extends CanvasLayer

@export var experience_manager: Node

@onready var progress_bar = %ProgressBar as ProgressBar


func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_update)


func on_experience_update(cur_exp: float, target_exp: float):
	var experience_percent = cur_exp / target_exp
	progress_bar.value = experience_percent
