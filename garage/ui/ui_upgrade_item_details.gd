class_name UIUpgradeItemDetails
extends Control

signal item_equipped_changed(to: bool)

@export var item: UpgradeItem : set = _set_item

@onready var label_title: Label = %LabelTitle
@onready var label_description: Label = %LabelDescription

@onready var texture_rect_icon: TextureRect = %TextureRectIcon


@onready var button_upgrade: Button = %ButtonUpgrade
@onready var button_equip: Button = %ButtonEquip

@onready var panel_visible: Panel = $PanelVisible

@onready var center_container_empty: CenterContainer = $CenterContainerEmpty

func _ready() -> void:
	update_ui()
	
	Game.save.coins_changed.connect(_on_save_coins_changed)

func update_ui() -> void:
	panel_visible.visible = item != null
	center_container_empty.visible = item == null
	
	if item != null:
		label_description.text = item.definition.description
		texture_rect_icon.texture = item.definition.texture
		update_title()
		update_equip_button()
		update_upgrade_button()

func connect_item(from_item: UpgradeItem) -> void:
	from_item.equipped_changed.connect(_on_item_equipped_changed)
	from_item.level_changed.connect(_on_item_level_changed)

func disconnect_item(from_item: UpgradeItem) -> void:
	from_item.equipped_changed.disconnect(_on_item_equipped_changed)
	from_item.level_changed.disconnect(_on_item_level_changed)

func update_title() -> void:
	label_title.text = "%s +%d/%d" % [item.definition.title, item.level, item.definition.max_level]

func update_equip_button() -> void:
	button_equip.disabled = !item.can_equip() and !item.is_equipped
	button_equip.text = "Unequip" if item.is_equipped else "Equip"

func update_upgrade_button() -> void:
	if item.is_maxed():
		button_upgrade.text = "Max"
		button_upgrade.disabled = true
	else:
		button_upgrade.disabled = !item.can_afford()
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
	if item.is_equipped:
		item.is_equipped = false
	else:
		item.try_equip()


func _on_button_upgrade_pressed() -> void:
	item.try_upgrade()


func _on_item_level_changed(_to: int) -> void:
	update_upgrade_button()
	update_title()


func _on_item_equipped_changed(equipped: bool) -> void:
	update_equip_button()
	item_equipped_changed.emit(equipped)

func _on_save_coins_changed(_to: int) -> void:
	update_upgrade_button()
