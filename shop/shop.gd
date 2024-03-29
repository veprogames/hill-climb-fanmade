extends Node2D

@onready var ui_shop_upgrade_item_offer_list: UIShopUpgradeItemOfferList = $CanvasLayer/CenterContainer/UIShopUpgradeItemOfferList

@onready var ui_shop_offer_refresh: UIShopOffer = $CanvasLayer/VBoxContainer/UIShopOfferRefresh

func _ready() -> void:
	ui_shop_offer_refresh.offer = Game.save.shop.refresh_offer


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
