extends CanvasLayer

@export var arena_time_manager: Node
@onready var label  = %Label

func _process(delta):
	if(arena_time_manager == null):
		return
	
	var time_elapsed: int = arena_time_manager.get_time_elapsed()
	label.text = format_time_elapsed(time_elapsed)


func format_time_elapsed(seconds):
	var minutes = seconds / 60
	var remaining_seconds =  seconds - (minutes * 60)
	#%02d forces that there has to be 2 digits in the string even if the number is only 1 and not > than 10
	return str(minutes) + ":" + ("%02d" % remaining_seconds)
