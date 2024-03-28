class_name FuelBar
extends ProgressBar

@onready var label_next_fuel: Label = $LabelNextFuel

@export var show_next_fuel: bool = false : set = _set_show_next_fuel
@export var next_fuel_value: float = 0.0 : set = _set_next_fuel_value

var stylebox_fill: StyleBoxFlat
var fuel_gradient: Gradient = Gradient.new()

func _ready() -> void:
	stylebox_fill = get_theme_stylebox("fill").duplicate()
	add_theme_stylebox_override("fill", stylebox_fill)
	
	fuel_gradient.set_color(0, Color(0.89, 0.176, 0.176))
	fuel_gradient.set_color(1, stylebox_fill.bg_color)
	fuel_gradient.add_point(0.5, Color(0.89, 0.878, 0.176))

func _set_show_next_fuel(show_it: bool) -> void:
	show_next_fuel = show_it
	
	if not is_node_ready():
		await ready
	
	label_next_fuel.visible = show_it

func _set_next_fuel_value(val: float) -> void:
	next_fuel_value = val
	
	if not is_node_ready():
		await ready
	
	label_next_fuel.text = "%s m" % F.F(val)

func _on_value_changed(value_: float) -> void:
	stylebox_fill.bg_color = fuel_gradient.sample(value_)
