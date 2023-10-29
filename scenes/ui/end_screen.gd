extends CanvasLayer


func _ready():
	get_tree().paused = true
	$%Restart.pressed.connect(on_restart_pressed)
	$%Quit.pressed.connect(on_quit_pressed)
	
	if(GameEvents.is_player_dead):
		set_defeat()


func set_defeat():
	$AnimationPlayer.play("fail_animation")
	$%Title.text = "Defeat"
	$%Description.text = "You lost"


func on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	


func play_victory_animation():
	$AnimationPlayer.play("victory_animation")


func on_quit_pressed():
	get_tree().quit()
