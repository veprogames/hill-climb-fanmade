class_name GemCollectible
extends BaseCollectible


func _on_collected(_by: Car) -> void:
	Global.save.gems += 1
