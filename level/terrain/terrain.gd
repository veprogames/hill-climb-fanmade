class_name Terrain
extends StaticBody2D

@onready var ss_2d_shape: SS2D_Shape = $SS2D_Shape

var noise: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	noise.seed = 42
	
	var vertices: PackedVector2Array = generate()
	
	for vertex: Vector2 in vertices:
		var key: int = ss_2d_shape.add_point(vertex)
		ss_2d_shape.set_point_in(key, Vector2.LEFT * 320)
		ss_2d_shape.set_point_out(key, Vector2.RIGHT * 320)
	
	ss_2d_shape.close_shape()

func generate() -> PackedVector2Array:
	var count: int = 128
	var x: float = -6400
	
	var result = PackedVector2Array()
	result.append(Vector2(x, 10000))
	for i in range(count):
		x += 640.0
		var amp: float = 300 + x / 50.0
		var y: float = noise.get_noise_1d(x / 50.0) * amp + 1000
		result.append(Vector2(x, y))
	result.append(Vector2(x, 10000))
	return result
