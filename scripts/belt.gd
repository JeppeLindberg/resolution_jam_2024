extends Node2D

@onready var main = get_node('/root/main')
@onready var line = get_node('line');

@export var relay_prefab: PackedScene


func _ready():
	add_to_group('belt')

func update(points):
	if main == null:
		main = get_node('/root/main')

	for relay in main.get_children_in_groups(self, ['relay']):
		relay.queue_free()

	for point in points:
		var new_relay = main.create_node(relay_prefab, self)
		new_relay.global_position = point
	
	line.recreate = true;

func approve():
	line.approve()

func check_cull():
	var recievers = main.get_nodes_at(line.points[len(line.points)-1], ['reciever'])
	for reciever in recievers:
		if reciever.visible:
			return

	queue_free()

