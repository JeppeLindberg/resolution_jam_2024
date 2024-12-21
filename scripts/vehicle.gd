extends PathFollow2D

@onready var main = get_node('/root/main')
@onready var points = get_node('/root/main/world/points')
@onready var shape_holder = get_node('shape_holder')

@export var dissipate_shape_prefab: PackedScene

var _shape = null


func _ready():
	add_to_group('vehicle')

func set_new_shape(shape_prefab):	
	if shape_holder == null:
		shape_holder = get_node('shape_holder')
	main.create_node(shape_prefab, shape_holder)

func set_shape(shape):	
	if shape_holder == null:
		shape_holder = get_node('shape_holder')
	shape.reparent(shape_holder)
	shape.position = Vector2.ZERO;

func _process(delta: float) -> void:
	_init_shape()

	var prev_progress = progress
	var path = get_parent()
	progress += delta * main.delta_mult * path.speed_mult * 100.0
	if progress < prev_progress:
		progress_ratio = 1.0

		for receiver in main.get_nodes_at(global_position, ['receiver']):
			if receiver.can_recieve_shape(_shape):
				receiver.recieve_shape(_shape)
				queue_free()
				return

		for emitter in main.get_nodes_at(global_position, ['emitter']):
			emitter.emit_shape(_shape)
			queue_free()
			return

		queue_free()

func _init_shape():
	if _shape == null:
		var shapes = main.get_children_in_groups(self, ['shape'], true)
		if len(shapes) > 0:
			_shape = shapes[0]

func get_shape():
	_init_shape()

	return _shape

func dissipate_shape():
	_init_shape()

	var children = main.get_children_in_groups(_shape, [], true)

	for child in children:
		if child is Sprite2D:
			var dissipate_shape_node = main.create_node(dissipate_shape_prefab, self)
			dissipate_shape_node.global_position = child.global_position
			dissipate_shape_node.global_scale = child.global_scale
			dissipate_shape_node.texture = child.texture
			dissipate_shape_node.self_modulate = child.self_modulate

