extends Node2D

@export var image_to_display: Texture

func _ready():
	$Sprite2D.texture = image_to_display
	
	global_position.y -= 10
	global_position.x += 10
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(1, 1), .2)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", Vector2.ZERO, .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	
	tween.parallel().tween_property(self, "global_position", (global_position + Vector2(0, -16)), .5)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(queue_free)
