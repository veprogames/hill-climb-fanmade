extends Node2D

@onready var ui_shop_upgrade_item_offer_list: UIShopUpgradeItemOfferList = %UIShopUpgradeItemOfferList

@onready var ui_shop_offer_refresh: UIShopOffer = $CanvasLayer/VBoxContainer/UIShopOfferRefresh

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	ui_shop_offer_refresh.offer = Game.save.shop.refresh_offer
	
	ui_shop_offer_refresh.bought.connect(_on_offer_refresh_bought)


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_offer_refresh_bought() -> void:
	Game.save.shop.refresh()


func _on_ui_shop_upgrade_item_offer_list_item_offer_pressed(with_confirmation: ShopItemOfferBuyModal) -> void:
	canvas_layer.add_child(with_confirmation)
