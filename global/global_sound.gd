extends Node

# use case: playing sounds for nodes that are to be deleted

func play(stream: AudioStream, volume_db: float = 0.0) -> void:
	var node: AudioStreamPlayer = AudioStreamPlayer.new()
	node.stream = stream
	node.volume_db = volume_db
	add_child(node)
	node.play()
	await node.finished
	node.queue_free()
