extends Path2D

@onready var main = get_node('/root/main')

@export var vehicle_prefab: PackedScene


func _ready() -> void:
	add_to_group('path')

func has_space_at(pos):
	if curve.point_count == 0:
		return(false)

	if curve.get_point_position(0) != pos:
		return(false)

	for child in get_children():
		if child.progress < 30.0:
			return(false)
			
	return(true)

func add_new_shape(shape_prefab):
	var new_vehicle = main.create_node(vehicle_prefab, self)
	new_vehicle.global_position = curve.get_point_position(0)
	main.create_node(shape_prefab, new_vehicle)

func approve():
	var new_curve = Curve2D.new()
	new_curve.bake_interval = 1.0

	for point in get_parent().points:
		new_curve.add_point(point)
	
	curve = new_curve