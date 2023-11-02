extends CanvasLayer

@export var meta_upgrades: Array[MetaUpgrade]

@onready var grid_container = %GridContainer

var meta_upgrade_card = preload("res://scenes/ui/meta_upgrade_card.tscn")

func _ready():
	set_upgrade_cards()


func set_upgrade_cards():
	for upgrade in meta_upgrades:
		var meta_card_instance = meta_upgrade_card.instantiate()
		grid_container.add_child(meta_card_instance)
		meta_card_instance.set_meta_upgrade(upgrade)
