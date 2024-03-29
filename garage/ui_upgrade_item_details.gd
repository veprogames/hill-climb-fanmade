class_name UIUpgradeItemDetails
extends Control

@export var item: UpgradeItem : set = _set_item

@onready var label_title: Label = $VBoxContainerDetails/HBoxContainer/LabelTitle
@onready var label_description: Label = $VBoxContainerDetails/LabelDescription

@onready var button_upgrade: Button = $VBoxContainerDetails/HBoxContainerActions/ButtonUpgrade
@onready var button_equip: Button = $VBoxContainerDetails/HBoxContainerActions/ButtonEquip

@onready var v_box_container_details: VBoxContainer = $VBoxContainerDetails
@onready var center_container_empty: CenterContainer = $CenterContainerEmpty

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	v_box_container_details.visible = item != null
	center_container_empty.visible = item == null
	
	if item != null:
		label_title.text = item.definition.title
		label_description.text = item.definition.description
		button_equip.text = "Unequip" if item.is_equipped else "Equip"
		update_upgrade_button()

func connect_item(from_item: UpgradeItem) -> void:
	from_item.equipped_changed.connect(_on_item_equipped_changed)
	from_item.level_changed.connect(_on_item_level_changed)

func disconnect_item(from_item: UpgradeItem) -> void:
	from_item.equipped_changed.disconnect(_on_item_equipped_changed)
	from_item.level_changed.disconnect(_on_item_level_changed)

func update_upgrade_button() -> void:
	if item.is_maxed():
		button_upgrade.text = "Max"
		button_upgrade.disabled = true
	else:
		button_upgrade.disabled = false
		button_upgrade.text = F.F(item.get_current_price())

func _set_item(new_item: UpgradeItem) -> void:
	if item != null:
		disconnect_item(item)
	
	item = new_item
	connect_item(item)
	
	if not is_node_ready():
		await ready
	
	update_ui()


func _on_button_equip_pressed() -> void:
	item.is_equipped = !item.is_equipped


func _on_button_upgrade_pressed() -> void:
	item.try_upgrade()


func _on_item_level_changed(_to: int) -> void:
	update_upgrade_button()


func _on_item_equipped_changed(equipped: bool) -> void:
	button_equip.text = "Unequip" if equipped else "Equip"
