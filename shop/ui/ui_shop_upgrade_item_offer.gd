class_name UIShopUpgradeItemOffer
extends Control

@onready var offer: ShopUpgradeItemOffer

@onready var texture_button_buy: TextureButton = $TextureButtonBuy
@onready var label_price: Label = $LabelPrice

func _ready() -> void:
	texture_button_buy.texture_normal = offer.definition.texture
	label_price.text = F.F(offer.price)
	
	offer.bought.connect(_on_offer_bought)
	offer.removed.connect(_on_offer_removed)


func _on_offer_bought() -> void:
	var item: UpgradeItem = UpgradeItem.new(offer.definition)
	Game.save.garage.add_item(item)
	
	Game.save.shop.refresh()


func _on_offer_removed() -> void:
	queue_free()


func _on_texture_button_buy_pressed() -> void:
	offer.try_buy()
