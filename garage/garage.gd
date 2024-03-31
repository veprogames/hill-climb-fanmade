extends Node2D

@onready var label_equip_count: Label = %LabelEquipCount

@onready var ui_upgrade_item_details: UIUpgradeItemDetails = %UIUpgradeItemDetails

var garage: SaveGameGarage = Game.save.garage

func _ready() -> void:
	update_equipped_text()

func update_equipped_text() -> void:
	label_equip_count.text = "%d / %d" % [garage.get_equipped_count(), SaveGameGarage.MAX_EQUIPS]

func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_ui_upgrade_item_list_item_selected(item: UpgradeItem) -> void:
	ui_upgrade_item_details.item = item


func _on_ui_upgrade_item_details_item_equipped_changed(_to: bool) -> void:
	update_equipped_text()
