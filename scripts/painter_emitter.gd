extends StaticBody2D

@onready var main = get_node('/root/main')
@onready var collider = get_node('collider')
@onready var belts = get_node('/root/main/world/belts')
@onready var painter = get_parent()

@export var active_from = 0
@export var inactive_from = 9999

func _ready() -> void:
	add_to_group('point')
	add_to_group('emitter')

func emit_shape(shape):
	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			path.add_shape(shape)

func deactivate():
	painter.deactivate()

func activate():
	painter.activate()
