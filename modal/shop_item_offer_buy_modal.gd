class_name ShopItemOfferBuyModal
extends YesNoModal

@export var offer: ShopUpgradeItemOffer

@onready var button_yes: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainerActions/ButtonYes

func _ready() -> void:
	super._ready()
	
	assert(offer != null)
	
	rich_text_label.text = "Do you want to buy this?
[color=lime]%s[/color]: %s" % [offer.definition.title, offer.definition.description]
	
	button_yes.disabled = !offer.can_afford()


func _on_yes_pressed() -> void:
	offer.try_buy()
