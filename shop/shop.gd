extends Node2D

const ModalScene: PackedScene = preload("res://modal/shop_item_offer_buy_modal.tscn")

@onready var ui_shop_upgrade_item_offer_list: UIShopUpgradeItemOfferList = %UIShopUpgradeItemOfferList

@onready var ui_shop_offer_refresh: UIShopOffer = $CanvasLayer/VBoxContainer/UIShopOfferRefresh

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	ui_shop_offer_refresh.offer = Game.save.shop.refresh_offer
	
	Game.save.shop.item_offer_pressed.connect(_on_shop_item_offer_pressed)
	ui_shop_offer_refresh.bought.connect(_on_offer_refresh_bought)


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_offer_refresh_bought() -> void:
	Game.save.shop.refresh()


func _on_shop_item_offer_pressed(offer: ShopUpgradeItemOffer) -> void:
	var modal: ShopItemOfferBuyModal = ModalScene.instantiate() as ShopItemOfferBuyModal
	modal.offer = offer
	canvas_layer.add_child(modal)
