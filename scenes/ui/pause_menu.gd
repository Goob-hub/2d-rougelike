extends CanvasLayer

var options_scene = preload("res://scenes/ui/options.tscn")

func _ready():
	$%ResumeButton.pressed.connect(on_resume_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitToMenuButton.pressed.connect(on_quit_to_menu_pressed)


func on_resume_pressed():
	$AnimationPlayer.play("exit")


func unpause_game():
	get_tree().paused = false


func on_options_pressed():
	var options_instance = options_scene.instantiate() 
	add_child(options_instance)
	options_instance.layer += 1


func on_quit_to_menu_pressed():
	get_tree().paused = false
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

