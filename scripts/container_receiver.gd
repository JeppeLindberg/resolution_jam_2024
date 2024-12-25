extends StaticBody2D

@onready var main = get_node('/root/main')
@onready var collider = get_node('collider')
@onready var container = get_parent()

@export var active_from = 0
@export var inactive_from = 9999


func _ready() -> void:
	add_to_group('point')
	add_to_group('receiver')
	
func can_receive_shape(_shape):
	var vehicles = main.get_children_in_groups(container, ['vehicle'], true)
	for vehicle in vehicles:
		if vehicle.progress < 30.0:
			return(false)
	return(true)

func receive_shape(shape):
	var paths = main.get_children_in_groups(container, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			path.add_shape(shape)
			return;


func deactivate():
	container.deactivate()

func activate():
	container.activate()
