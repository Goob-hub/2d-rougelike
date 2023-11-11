extends Node2D

var damage_done: float = 0
var amount_healed: float = 0

@export var text_color_on_heal:Color

func _ready():
	if(damage_done == 0):
		$Label.text = str(amount_healed)
		$Label.add_theme_color_override("font_color", text_color_on_heal)
	else:
		$Label.text = str(damage_done)
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(1, 1), .2)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", Vector2.ZERO, .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	
	tween.parallel().tween_property(self, "global_position", (global_position + Vector2(0, -12)), .5)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(queue_free)
