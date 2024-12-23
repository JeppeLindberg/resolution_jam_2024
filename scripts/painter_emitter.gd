extends StaticBody2D

@onready var main = get_node('/root/main')
@onready var collider = get_node('collider')
@onready var belts = get_node('/root/main/world/belts')
@onready var painter = get_parent()
@onready var buffer = get_node_or_null('buffer')

@export var active_from = 0
@export var inactive_from = 9999

func _ready() -> void:
	add_to_group('point')
	add_to_group('emitter')

func can_emit_shape(_shape):
	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			return(true)
	
	return(false)

func emit_shape(shape):
	buffer.add_buffer_shape(shape)

	var outgoing_belts = _number_of_outgoing_belts()
	var buffer_shapes = buffer.number_of_buffer_shapes()
	if buffer_shapes < outgoing_belts:
		return

	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			print('bla')
			path.add_shape(buffer.pop())

	buffer.cleanup()

func deactivate():
	painter.deactivate()

func activate():
	painter.activate()

func _number_of_outgoing_belts():
	var result = 0
	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.curve.point_count > 0 and path.curve.get_point_position(0).distance_to(global_position) < 1.0:
			result += 1
	
	return(result)

func can_create_new_belt():
	return(true)
