extends ProgressBar

@export var health_component: HealthComponent

func _ready():
	value = 1
	health_component.dead.connect(on_dead)
	health_component.damaged.connect(on_damaged)
	health_component.healed.connect(on_heal)


func on_dead():
	queue_free()


func on_damaged():
	if(health_component == null):
		return
	value = health_component.get_health_percent()


func on_heal(_amount_healed: float):
	if(health_component == null):
		return
	value = health_component.get_health_percent()
