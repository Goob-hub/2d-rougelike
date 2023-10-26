extends Area2D
class_name HurtBoxComponent

@export var health_component: HealthComponent
@export var floating_text: PackedScene

func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if(not other_area is HitBoxComponent):
		return
	
	if(health_component == null):
		return
	
	var hitbox_component = other_area as HitBoxComponent
	
	var enemy_pos = owner.global_position
	var dmg_txt = floating_text.instantiate()
	
	dmg_txt.damage_done = hitbox_component.damage
	dmg_txt.global_position = enemy_pos
	
	owner.get_tree().get_first_node_in_group("foreground_layer").add_child(dmg_txt)
	
	health_component.damage(hitbox_component.damage)
