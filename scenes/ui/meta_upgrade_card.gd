extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_label: Label = %ProgressLabel 
@onready var progress_bar: ProgressBar = %ProgressToPurchase
@onready var purchase_button = %PurchaseButton

var meta_upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func starting_animation(delay: float):
	modulate.a = 0
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("bounce_in")


func set_meta_upgrade(upgrade: MetaUpgrade):
	meta_upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	
	progress_label.text = str(MetaProgression.save_data.upgrade_currency_amount)\
	+ "/" + str(upgrade.experience_cost)
	
	set_progress_bar()


func set_progress_bar():
	var progress_percent = minf(MetaProgression.save_data.upgrade_currency_amount / meta_upgrade.experience_cost, 1.0)
	progress_bar.value = progress_percent
	
	if(progress_percent < 1):
		purchase_button.disabled = true


func on_purchase_pressed():
	$HoverAnimation.play("selected")
	MetaProgression.save_data.upgrade_currency_amount -= meta_upgrade.experience_cost
	MetaProgression.add_meta_upgrade(meta_upgrade)
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_cards", "set_progress_bar")
