extends PanelContainer

signal purchase_made

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_label: Label = %ProgressLabel 
@onready var progress_bar: ProgressBar = %ProgressToPurchase
@onready var purchase_button = %PurchaseButton
@onready var amount_label = %AmountLabel

var meta_upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func starting_animation(delay: float):
	modulate.a = 0
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("bounce_in")


func set_meta_upgrade(upgrade: MetaUpgrade):
	if(upgrade == null and not meta_upgrade):
		print("No upgrades are valid for cards to display")
	
	if(not meta_upgrade):
		meta_upgrade = upgrade
	
	if(upgrade == null):
		upgrade = meta_upgrade
	
	var current_quantity = 0
	if(MetaProgression.save_data.meta_upgrades.has(upgrade.id)):
		current_quantity = MetaProgression.save_data.meta_upgrades[upgrade.id].quantity
	
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	amount_label.text = "Level " + str(current_quantity)
	
	progress_label.text = str(MetaProgression.save_data.upgrade_currency_amount)\
	+ "/" + str(upgrade.experience_cost)
	
	set_progress_bar(current_quantity)


func set_progress_bar(current_quantity: int):
	
	if(current_quantity and meta_upgrade and MetaProgression.save_data.meta_upgrades.has(meta_upgrade.id)):
		current_quantity = MetaProgression.save_data.meta_upgrades[meta_upgrade.id].quantity
	else:
		current_quantity = 0
	
	
	var is_max_level = current_quantity >= meta_upgrade.max_quantity
	var progress_percent = minf(MetaProgression.save_data.upgrade_currency_amount / meta_upgrade.experience_cost, 1.0)
	progress_bar.value = progress_percent
	
	if(progress_percent < 1):
		purchase_button.disabled = true
	
	if(is_max_level):
		purchase_button.disabled = true
		purchase_button.text = "Max level"


func on_purchase_pressed():
	$HoverAnimation.play("selected")
	if(not MetaProgression.save_data.meta_upgrades.has(meta_upgrade.id)):
		MetaProgression.save_data.upgrade_currency_amount -= meta_upgrade.experience_cost
		MetaProgression.add_meta_upgrade(meta_upgrade)
	else:
		MetaProgression.save_data.upgrade_currency_amount -= meta_upgrade.experience_cost
		MetaProgression.save_data.meta_upgrades[meta_upgrade.id].quantity += 1
		MetaProgression.save()
	
	for card in get_tree().get_nodes_in_group("meta_upgrade_cards"):
		card.set_meta_upgrade(null)
	
	set_meta_upgrade(meta_upgrade)
