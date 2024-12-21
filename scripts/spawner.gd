extends StaticBody2D



@export var spawn_shape: PackedScene

@onready var main = get_node('/root/main')
@onready var inventory_count = get_node('inventory_count/count')
@onready var shape_holder = get_node('inventory_count/shape_holder')
@onready var belts = get_node('/root/main/world/belts')
@onready var collider = get_node('collider')

@export var active_from = 0
@export var inactive_from = 9999
var current_inventory = 0.0
@export var max_inventory: float = 5.0


func _ready() -> void:
	add_to_group('point')
	add_to_group('spawner')
	add_to_group('emitter')
	main.create_node(spawn_shape, shape_holder)
	_update_text()
	deactivate()

func _process(delta: float) -> void:
	current_inventory += delta * main.delta_mult
	if current_inventory > max_inventory:
		current_inventory = max_inventory

	var needed_inventory = 0.0
	var paths = main.get_children_in_groups(belts, ['path'], true)
	for path in paths:
		if path.has_space_at(global_position):
			needed_inventory += 1.0
		
	if needed_inventory == 0.0:
		needed_inventory = 1.0

	if current_inventory >= needed_inventory:
		for path in paths:
			if path.has_space_at(global_position):
				path.add_new_shape(spawn_shape)

				current_inventory -= 1.0

	_update_text()

func _update_text() -> void:
	inventory_count.text = str(int(current_inventory)) + '/' + str(int(max_inventory))

func deactivate():
	visible = false
	collider.disabled = true

func activate():
	visible = true
	collider.disabled = false
	current_inventory = 0.0;