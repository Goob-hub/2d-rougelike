extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"global_difficulty": "Normal",
	"upgrade_currency_amount": 0,
	"meta_upgrades": {}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_exp_collected)
	load_save()


func load_save():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if(not save_data.meta_upgrades.has(upgrade.id)):
		save_data.meta_upgrades[upgrade.id] = {
			"name": upgrade.title,
			"quantity": 0,
			"value_percent": upgrade.value_percent
		}
	
	save_data.meta_upgrades[upgrade.id].quantity += 1
	save()


func on_exp_collected(number: float):
	save_data.upgrade_currency_amount += number


func get_meta_upgrade(upgrade_id: String):
	if(save_data.meta_upgrades.has(upgrade_id)):
		return save_data.meta_upgrades[upgrade_id]
	else:
		return null


func change_difficulty(difficulty: String):
	save_data.global_difficulty = difficulty
	save()


func get_current_difficulty():
	if(save_data.has("global_difficulty")):
		return save_data.global_difficulty.to_lower()
	else:
		save_data.global_difficulty = "Normal"
		return save_data.global_difficulty.to_lower()
