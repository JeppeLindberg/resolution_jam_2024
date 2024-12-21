extends StaticBody2D



@export var consume_shape: PackedScene

@onready var main = get_node('/root/main')
@onready var inventory_count = get_node('inventory_count/count')
@onready var shape_holder = get_node('inventory_count/shape_holder')

var current_inventory = 0.0


func _ready() -> void:
	main.create_node(consume_shape, shape_holder)
	inventory_count.text = str(int(current_inventory))


func _process(_delta: float) -> void:
	inventory_count.text = str(int(current_inventory))


