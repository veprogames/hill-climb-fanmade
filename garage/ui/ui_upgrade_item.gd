class_name UIUpgradeItem
extends Control

const COLOR_EQUIPPED: Color = Color(0, 0.702, 0.412) * 2.5

@export var item: UpgradeItem

@onready var texture_item: TextureRect = $TextureItem
@onready var label_level: Label = $LabelLevel
@onready var texture_button: TextureButton = $TextureButton

func _ready() -> void:
	texture_button.modulate = COLOR_EQUIPPED if item.is_equipped else Color.WHITE
	texture_item.texture = item.definition.texture
	label_level.text = "+%d" % item.level
	
	item.equipped.connect(_on_item_equipped)
	item.unequipped.connect(_on_item_unequipped)
	item.level_changed.connect(_on_item_level_changed)

func _on_item_equipped() -> void:
	texture_button.modulate = COLOR_EQUIPPED

func _on_item_unequipped() -> void:
	texture_button.modulate = Color.WHITE

func _on_item_level_changed(to: int) -> void:
	label_level.text = "+%d" % to

func _on_texture_button_pressed() -> void:
	Game.save.garage.item_selected.emit(item)
