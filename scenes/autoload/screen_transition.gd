extends CanvasLayer

signal transitioned_halfway

var skip_emit = false

func _transition():
	$AnimationPlayer.play("base animation")
	await transitioned_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("base animation")


func _emit_transitioned():
	if(skip_emit):
		skip_emit = false
		return
	transitioned_halfway.emit()


func transition_to_scene(scene_path: String):
	_transition()
	await transitioned_halfway
	get_tree().change_scene_to_file(scene_path)
