extends StaticBody2D



@export var spawn_shape: PackedScene

@onready var main = get_node('/root/main')
@onready var inventory_count = get_node('inventory_count/count')
@onready var shape_holder = get_node('inventory_count/shape_holder')
@onready var belts = get_node('/root/main/world/belts')

var current_inventory = 0.0


func _ready() -> void:
	main.create_node(spawn_shape, shape_holder)
	inventory_count.text = str(int(current_inventory))


func _process(delta: float) -> void:
	current_inventory += delta

	if current_inventory >= 1.0:
		var paths = main.get_children_in_groups(belts, ['path'], true)
		for path in paths:
			if path.has_space_at(global_position):
				path.add_new_shape(spawn_shape)

				current_inventory -= 1.0

	inventory_count.text = str(int(current_inventory))
