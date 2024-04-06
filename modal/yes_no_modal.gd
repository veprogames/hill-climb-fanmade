class_name YesNoModal
extends BaseActionModal

signal yes_pressed
signal no_pressed


func _on_button_yes_pressed() -> void:
	yes_pressed.emit()
	close()


func _on_button_no_pressed() -> void:
	no_pressed.emit()
	close()
