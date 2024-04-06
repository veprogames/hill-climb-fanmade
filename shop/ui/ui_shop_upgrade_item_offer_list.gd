class_name UIShopUpgradeItemOfferList
extends HFlowContainer

signal item_offer_pressed(with_confirmation: ShopItemOfferBuyModal)

var OfferScene: PackedScene = preload("res://shop/ui/ui_shop_upgrade_item_offer.tscn")

func _ready() -> void:
	for offer: ShopUpgradeItemOffer in Game.save.shop.item_offers:
		add_offer(offer)
	
	Game.save.shop.item_offer_added.connect(_on_shop_item_offer_added)

func add_offer(offer: ShopUpgradeItemOffer) -> void:
	var ui_offer: UIShopUpgradeItemOffer = OfferScene.instantiate() as UIShopUpgradeItemOffer
	ui_offer.offer = offer
	ui_offer.pressed.connect(_on_shop_item_offer_pressed)
	add_child(ui_offer)


func _on_shop_item_offer_added(offer: ShopUpgradeItemOffer) -> void:
	add_offer(offer)


func _on_shop_item_offer_pressed(with_confirmation: ShopItemOfferBuyModal) -> void:
	item_offer_pressed.emit(with_confirmation)
