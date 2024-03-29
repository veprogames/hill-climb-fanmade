extends Node2D

@onready var ui_upgrade_item_details: UIUpgradeItemDetails = $CanvasLayer/UIUpgradeItemDetails

func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_ui_upgrade_item_list_item_selected(item: UpgradeItem) -> void:
	ui_upgrade_item_details.item = item
