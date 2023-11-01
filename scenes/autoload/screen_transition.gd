extends CanvasLayer

signal transitioned_halfway

var skip_emit = false

func transition():
	$AnimationPlayer.play("base animation")
	await transitioned_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("base animation")


func emit_transitioned():
	if(skip_emit):
		skip_emit = false
		return
	transitioned_halfway.emit()
