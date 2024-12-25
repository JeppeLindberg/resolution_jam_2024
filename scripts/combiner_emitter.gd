extends StaticBody2D

@onready var main = get_node('/root/main')
@onready var collider = get_node('collider')
@onready var belts = get_node('/root/main/world/belts')
@onready var combiner = get_parent()

@export var quad_shape_prefab: PackedScene
@export var active_from = 0
@export var inactive_from = 9999

func _ready() -> void:
	add_to_group('point')
	add_to_group('emitter')

func _process(_delta: float) -> void:
	if not combiner.visible:
		return
	if _number_of_outgoing_belts() == 0:
		return

	var ingoing_belts = main.get_children_in_groups(combiner, ['belt'])
	var ready_shapes = []
	var ready_vehicles = []
	for belt in ingoing_belts:
		var vehicles = main.get_children_in_groups(belt, ['vehicle'], true)
		if len(vehicles) > 0 and vehicles[0].progress_ratio == 1.0:
			ready_shapes.append(vehicles[0].get_shape())
			ready_vehicles.append(vehicles[0])
	
	if len(ready_shapes) == 4 and can_emit_shape(null, true):
		var shape = main.create_node(quad_shape_prefab, self)
		shape.create_from(ready_shapes)
		emit_shape(shape)
		for vehicle in ready_vehicles:
			vehicle.queue_free()

func can_emit_shape(_shape, called_from_self = false):
	if not called_from_self:
		return(false)

	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			return(true)
	
	return(false)

func emit_shape(shape):
	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			path.add_shape(shape)

func deactivate():
	combiner.deactivate()

func activate():
	combiner.activate()

func _number_of_outgoing_belts():
	var result = 0
	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.curve.point_count > 0 and path.curve.get_point_position(0).distance_to(global_position) < 1.0:
			result += 1
	
	return(result)

func can_create_new_belt():
	if _number_of_outgoing_belts() == 0:
		return(true)
	return(false)

func allow_connect_to(_receiver):
	# var receivers = main.get_children_in_groups(combiner, ['receiver'])
	# if receivers.find(receiver) != -1:
	# 	return(false)

	return(true)
