extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var is_clicked = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func starting_animation(delay: float):
	modulate.a = 0
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("bounce_in")
	


func play_discard():
	$HoverAnimation.play("discard")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	if(is_clicked):
		return
	
	if(Input.is_action_just_pressed("left_click") and !is_clicked):
		is_clicked = true
		on_card_select()


func on_card_select():
	$HoverAnimation.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_cards"):
		if other_card == self:
			continue
		else:
			other_card.play_discard()
	
	await $HoverAnimation.animation_finished
	selected.emit()


func on_mouse_entered():
	if(!is_clicked):
		$HoverAnimation.play("hover")
