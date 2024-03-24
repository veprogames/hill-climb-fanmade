class_name FuelCollectible
extends BaseCollectible

func _on_collected(by: Car) -> void:
	by.refuel()
