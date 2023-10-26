extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
#When using shader resources, Make it a global variable and check the local to scene checkbox
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween

func _ready():
	health_component.damaged.connect(on_damage)
	sprite.material = hit_flash_material


func on_damage():
	if(hit_flash_tween != null && hit_flash_tween.is_valid()):
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .25)
