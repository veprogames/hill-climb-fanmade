class_name CarCamera
extends Camera2D

@export var car: Car

var car_died: bool = false

const BASE_ZOOM: Vector2 = Vector2.ONE * 0.55

func _ready() -> void:
	zoom = BASE_ZOOM
	
	car.died.connect(_on_car_died)

func _physics_process(delta: float) -> void:
	if not car_died:
		var zoom_multiplier: float = remap(car.linear_velocity.x, 0.0, 3000.0, 1.0, 0.75)
		zoom_multiplier = clampf(zoom_multiplier, 0.75, 1.0)
		zoom = zoom.lerp(BASE_ZOOM * zoom_multiplier, delta * 2.0)

func _on_car_died() -> void:
	car_died = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"zoom", BASE_ZOOM * 1.2, 2) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
