extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var ability_upgrade_card: PackedScene
@onready var card_container: HBoxContainer = %CardContainer

func _ready():
	#Set the elements process mode to always ONLY FOR THE ONES YOU WANT TO KEEP RUNNING
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	if(upgrades.size() == 0):
		return
	
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.starting_animation(delay)
		#When card is instantiated, connect to the selected signal and bind the upgrade to the callback func
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += .2


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
