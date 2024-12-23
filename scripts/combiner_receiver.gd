extends StaticBody2D

@onready var main = get_node('/root/main')
@onready var collider = get_node('collider')
@onready var combiner = get_parent()

@export var active_from = 0
@export var inactive_from = 9999


func _ready() -> void:
	add_to_group('point')
	add_to_group('receiver')

func can_receive_shape(_shape):
	var paths = main.get_children_in_groups(combiner, ['path'], true)
	for path in paths:
		if path.curve.get_point_position(0).distance_to(global_position) < 1.0:
			var vehicles = main.get_children_in_groups(path, ['vehicle'], true)
			if len(vehicles) > 0:
				return(false)

			return(true)

	return(true)

func receive_shape(shape):
	var paths = main.get_children_in_groups(combiner, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			path.add_shape(shape)
			return;

func deactivate():
	combiner.deactivate()

func activate():
	combiner.activate()
