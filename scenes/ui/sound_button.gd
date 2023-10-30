extends Button

func _ready():
	pressed.connect(on_pressed)


func on_pressed():
	$RandomSoundPlayerComponent.play_random_sound()
