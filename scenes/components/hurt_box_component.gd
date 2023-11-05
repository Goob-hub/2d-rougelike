extends Area2D
class_name HurtBoxComponent

signal hit

@export var health_component: HealthComponent
@export var floating_text: PackedScene

var has_block_ability = false
var ability_list = {}

func _ready():
	area_entered.connect(on_area_entered)
	if(get_parent().ability_list != null):
		ability_list = get_parent().ability_list


func on_area_entered(other_area: Area2D):
	if(not other_area is HitBoxComponent):
		return
	
	if(health_component == null):
		return
	
	if(ability_list.has("block_ability") and ability_list.block_ability.check_if_blocked()):
		return
	
	var hitbox_component = other_area as HitBoxComponent
	
	var enemy_pos = owner.global_position
	var dmg_txt = floating_text.instantiate()
	
	var format_string = "%0.1f"
	if(round(hitbox_component.damage) == hitbox_component.damage):
		format_string = "%0.0f"
	
	dmg_txt.damage_done = format_string % hitbox_component.damage
	dmg_txt.global_position = enemy_pos
	
	owner.get_tree().get_first_node_in_group("foreground_layer").add_child(dmg_txt)
	
	hit.emit()
	health_component.damage(hitbox_component.damage)
