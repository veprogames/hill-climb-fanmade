class_name UIUpgradeItem
extends Control

signal selected(item: UpgradeItem)

@export var item: UpgradeItem

@onready var texture_item: TextureRect = $TextureItem
@onready var label_level: Label = $LabelLevel
@onready var texture_equipped: TextureRect = $TextureEquipped

func _ready() -> void:
	texture_item.texture = item.definition.texture
	label_level.text = "+%d" % item.level
	texture_equipped.visible = item.is_equipped
	
	item.equipped.connect(_on_item_equipped)
	item.unequipped.connect(_on_item_unequipped)
	item.level_changed.connect(_on_item_level_changed)

func _on_item_equipped() -> void:
	texture_equipped.visible = true

func _on_item_unequipped() -> void:
	texture_equipped.visible = false

func _on_item_level_changed(to: int) -> void:
	label_level.text = "+%d" % to

func _on_texture_button_pressed() -> void:
	selected.emit(item)
