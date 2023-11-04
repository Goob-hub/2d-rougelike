extends CanvasLayer

var options_scene = preload("res://scenes/ui/options.tscn")


func _ready():
	$%EasyButton.pressed.connect(on_easy_pressed)
	$%NormalButton.pressed.connect(on_normal_pressed)
	$%HardButton.pressed.connect(on_hard_pressed)
	%BackButton.pressed.connect(on_back_pressed)
	update_buttons()


func on_easy_pressed():
	MetaProgression.change_difficulty("Easy")
	update_buttons()


func on_normal_pressed():
	MetaProgression.change_difficulty("Normal")
	update_buttons()


func on_hard_pressed():
	MetaProgression.change_difficulty("Hard")
	update_buttons()


func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")


func update_buttons():
	for button in get_tree().get_nodes_in_group("difficulty_buttons"):
		if(button.text.to_lower() == MetaProgression.get_current_difficulty()):
			button.disabled = true
		else:
			button.disabled = false
