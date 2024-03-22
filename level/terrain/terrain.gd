class_name Terrain
extends StaticBody2D

const VERTEX_GAP: float = 640.0
const DEEP_Y: float = 1_000_000.0

@onready var ss_2d_shape: SS2D_Shape = $SS2D_Shape
@onready var generation_border: GenerationBorder = $GenerationBorder
@onready var worldborder_l: StaticBody2D = $WorldborderL
@onready var worldborder_r: StaticBody2D = $WorldborderR

var noise: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	noise.seed = 42
	
	var vertices: PackedVector2Array = get_initial_vertices()
	
	for vertex: Vector2 in vertices:
		var key: int = ss_2d_shape.add_point(vertex)
		ss_2d_shape.set_point_in(key, Vector2.LEFT * 320)
		ss_2d_shape.set_point_out(key, Vector2.RIGHT * 320)
	
	ss_2d_shape.close_shape()
	
	update_base_vertices()

func get_y(for_x: float) -> float:
	var amp: float = 300 + for_x / 250.0
	var y: float = noise.get_noise_1d(for_x / 50.0) * amp + 1000
	return y

func get_first_terrain_vertex() -> SS2D_Point:
	return ss_2d_shape.get_point_at_index(1)

func get_last_terrain_vertex() -> SS2D_Point:
	return ss_2d_shape.get_point_at_index(ss_2d_shape.get_point_count() - 3)

func push_terrain_vertex() -> void:
	var last_terrain_vertex: SS2D_Point = get_last_terrain_vertex()
	var index_to_insert: int = ss_2d_shape.get_point_count() - 2
	
	var x: float = last_terrain_vertex.position.x + VERTEX_GAP
	var y: float = get_y(x)
	
	var key: int = ss_2d_shape.add_point(Vector2(x, y), index_to_insert)
	ss_2d_shape.set_point_in(key, Vector2.LEFT * 320)
	ss_2d_shape.set_point_out(key, Vector2.RIGHT * 320)

func pop_terrain_vertex() -> void:
	var first_terrain_index: int = 1
	
	ss_2d_shape.remove_point_at_index(first_terrain_index)

func update_base_vertices() -> void:
	var first_vertex: SS2D_Point = ss_2d_shape.get_point_at_index(0)
	var last_vertex: SS2D_Point = ss_2d_shape.get_point_at_index(ss_2d_shape.get_point_count() - 1)
	
	var first_terrain_vertex: SS2D_Point = get_first_terrain_vertex()
	var last_terrain_vertex: SS2D_Point = get_last_terrain_vertex()
	
	first_vertex.position.x = first_terrain_vertex.position.x
	last_vertex.position.x = last_terrain_vertex.position.x
	
	generation_border.position.x = last_terrain_vertex.position.x - VERTEX_GAP * 6
	worldborder_l.position.x = first_terrain_vertex.position.x + VERTEX_GAP * 6
	worldborder_r.position.x = last_terrain_vertex.position.x

func get_initial_vertices() -> PackedVector2Array:
	var count: int = 32
	var x: float = -VERTEX_GAP * 10.0
	
	var result = PackedVector2Array()
	result.append(Vector2(x, DEEP_Y))
	for i in range(count):
		x += VERTEX_GAP
		result.append(Vector2(x, get_y(x)))
	result.append(Vector2(x, DEEP_Y))
	return result


func _on_generation_border_car_entered() -> void:
	pop_terrain_vertex()
	push_terrain_vertex()
	update_base_vertices()
