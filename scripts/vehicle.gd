extends PathFollow2D

@onready var main = get_node('/root/main')
@onready var points = get_node('/root/main/world/points')
@onready var shape_holder = get_node('shape_holder')

var _shape = null


func _ready():
	add_to_group('vehicle')

func set_shape(shape_prefab):	
	if shape_holder == null:
		shape_holder = get_node('shape_holder')
	main.create_node(shape_prefab, shape_holder)

func _process(delta: float) -> void:
	if _shape == null:
		var shapes = main.get_children_in_groups(self, ['shape'], true)
		if len(shapes) > 0:
			_shape = shapes[0]

	var prev_progress = progress
	progress += delta * main.delta_mult * 100.0
	if progress < prev_progress:
		progress_ratio = 1.0
		for reciever in main.get_nodes_at(global_position, ['reciever']):
			if reciever.can_recieve_shape(_shape):
				reciever.recieve_shape(_shape)
				queue_free()
				return
		queue_free()
