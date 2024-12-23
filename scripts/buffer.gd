extends Node2D

@onready var main = get_node('/root/main')
@onready var offset = get_node('offset')
var buffer_holder = null

@export var buffer_holder_prefab: PackedScene


func add_buffer_shape(shape):
	var shape_holder = null;

	if offset.get_child_count() == 0:
		buffer_holder = main.create_node(buffer_holder_prefab, offset)
		shape_holder = buffer_holder.get_node('shape_holder')
		shape.reparent(shape_holder)
		shape.position = Vector2(0, 0)
	if offset.get_child_count() > 0:
		shape_holder = offset.get_child(0).get_node('shape_holder')
		var old_shape = shape_holder.get_child(0)
		if not old_shape.matches(shape):
			for child in get_children():
				child.free()
			add_buffer_shape(shape)
			return;
		shape.reparent(shape_holder)
		shape.position = Vector2(0, 0)

	for child in shape_holder.get_children():
		child.visible = false
	shape_holder.get_child(0).visible = true

	buffer_holder.get_node('count').set_text(str(shape_holder.get_child_count()))

func number_of_buffer_shapes():
	if offset.get_child_count() == 0:
		return(0)

	var shape_holder = buffer_holder.get_node('shape_holder')
	return(shape_holder.get_child_count())

func pop():
	var shape_holder = buffer_holder.get_node('shape_holder')
	var shape = shape_holder.get_child(0)
	shape.visible = true
	return(shape)

func cleanup():
	if offset.get_child_count() == 0:
		return

	var shape_holder = buffer_holder.get_node('shape_holder')
	if shape_holder.get_child_count() == 0:
		for child in offset.get_children():
			child.queue_free()

