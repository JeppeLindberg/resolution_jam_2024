extends StaticBody2D


@export var consume_shape: PackedScene

@onready var main = get_node('/root/main')
@onready var game = get_node('/root/main/game')
@onready var inventory_count = get_node('inventory_count/count')
@onready var shape_holder = get_node('inventory_count/shape_holder')
@onready var collider = get_node('collider')

var current_inventory = 0.0
@export var active_from = 0
@export var inactive_from = 9999
@export var max_inventory_dict: Dictionary = {0: 5.0, 1: 10.0}
@export var max_inventory: float = 5.0
@export var filled_color: Color
@export var empty_color: Color


func _ready() -> void:
	add_to_group('point')
	add_to_group('consumer')
	add_to_group('reciever')
	main.create_node(consume_shape, shape_holder)
	_update_text()
	deactivate()

func can_recieve_shape(shape):
	return(true)

func recieve_shape(shape):
	current_inventory += 1.0
	if current_inventory > max_inventory:
		current_inventory = max_inventory
	shape.queue_free()

func _process(_delta: float) -> void:
	_update_text()

func _update_text() -> void:
	inventory_count.text = str(int(current_inventory)) + '/' + str(int(max_inventory))
	inventory_count.self_modulate = empty_color
	if current_inventory == max_inventory:
		inventory_count.self_modulate = filled_color

func deactivate():
	visible = false
	collider.disabled = true

func activate():
	visible = true
	collider.disabled = false
	current_inventory = 0.0;

	if max_inventory_dict.has(game.current_stage):
		max_inventory = max_inventory_dict[game.current_stage]
	