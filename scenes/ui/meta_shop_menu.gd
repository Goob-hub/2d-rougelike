extends CanvasLayer

@export var meta_upgrades: Array[MetaUpgrade]

@onready var grid_container = %GridContainer
@onready var back_to_menu = %BackToMenu

var meta_upgrade_card = preload("res://scenes/ui/meta_upgrade_card.tscn")

func _ready():
	back_to_menu.pressed.connect(on_back_pressed)
	set_upgrade_cards()


func set_upgrade_cards():
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in meta_upgrades:
		var meta_card_instance = meta_upgrade_card.instantiate()
		grid_container.add_child(meta_card_instance)
		meta_card_instance.set_meta_upgrade(upgrade)


func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
