class_name UIUpgradeItem
extends Control

const COLOR_EQUIPPED: Color = Color(0, 0.702, 0.412) * 2.5
const COLOR_TUNED: Color = Color("#9edce2")

@export var item: UpgradeItem

@onready var texture_item: TextureRect = $TextureItem
@onready var label_level: Label = $LabelLevel
@onready var texture_button: TextureButton = $TextureButton

func _ready() -> void:
	texture_button.modulate = COLOR_EQUIPPED if item.is_equipped else Color.WHITE
	texture_item.texture = item.definition.texture
	update_label_level()
	
	item.equipped.connect(_on_item_equipped)
	item.unequipped.connect(_on_item_unequipped)
	item.level_changed.connect(_on_item_level_changed)
	item.tuned_level_changed.connect(_on_item_tuned_level_changed)

func update_label_level() -> void:
	if item.is_tuned():
		label_level.text = "+%d" % item.tuned_level
		label_level.modulate = COLOR_TUNED
	else:
		label_level.text = "+%d" % item.level
		label_level.modulate = Color.WHITE

func _on_item_equipped() -> void:
	texture_button.modulate = COLOR_EQUIPPED

func _on_item_unequipped() -> void:
	texture_button.modulate = Color.WHITE

func _on_item_level_changed(_to: int) -> void:
	update_label_level()

func _on_item_tuned_level_changed(_to: int) -> void:
	update_label_level()

func _on_texture_button_pressed() -> void:
	Game.save.garage.item_selected.emit(item)

func _handle_double_click() -> void:
	if !item.is_equipped:
		item.try_equip()
	else:
		item.is_equipped = false

func _on_texture_button_gui_input(event: InputEvent) -> void:
	# handle click event only
	# since emulate emulate_mouse_from_touch is enabled
	var click_event: InputEventMouseButton = event as InputEventMouseButton
	if click_event != null and click_event.pressed and \
			click_event.button_index == MOUSE_BUTTON_LEFT and \
			click_event.double_click:
		_handle_double_click()
