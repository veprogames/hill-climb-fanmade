class_name BaseActionModal
extends BaseModal

@onready var rich_text_label: RichTextLabel = %RichTextLabel

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	var string_meta: String = meta as String
	if string_meta != null and string_meta.begins_with("https://"):
		OS.shell_open(string_meta)
