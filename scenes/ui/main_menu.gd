extends CanvasLayer

var options_scene = preload("res://scenes/ui/options.tscn")

func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	%ShopButton.pressed.connect(on_shop_pressed)


func on_play_pressed():
	ScreenTransition.transition_to_scene("res://scenes/main/main.tscn")


func on_options_pressed():
	var options_instance = options_scene.instantiate() 
	add_child(options_instance)


func on_quit_pressed():
	ScreenTransition._transition()
	await ScreenTransition.transitioned_halfway
	get_tree().quit()


func on_shop_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/meta_shop_menu.tscn")
