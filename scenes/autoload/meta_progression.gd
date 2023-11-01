extends Node

var save_data: Dictionary = {
	"upgrade_currency_amount": 0,
	"meta_upgrades": {}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_exp_collected)
	add_meta_upgrade(preload("res://resources/meta_upgrades/vial_droprate.tres"))


func add_meta_upgrade(upgrade: MetaUpgrade):
	if(not save_data.meta_upgrades.has(upgrade)):
		save_data.meta_upgrades[upgrade.id] = {
			"name": upgrade.title,
			"quantity": 0,
			"value_percent": upgrade.value_percent
		}
	
	save_data.meta_upgrades[upgrade.id].quantity += 1
	print(save_data)


func on_exp_collected(number: float):
	save_data.upgrade_currency_amount += number
