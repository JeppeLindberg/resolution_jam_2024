extends Node2D

@onready var main = get_node('/root/main')

@export var active_from = 0

@export var reciever_1: Node2D
@export var reciever_2: Node2D
@export var reciever_3: Node2D
@export var reciever_4: Node2D
@export var drop_1: Node2D
@export var drop_2: Node2D
@export var drop_3: Node2D
@export var drop_4: Node2D
@export var emitter: Node2D
@export var belt_prefab: PackedScene

@export var new_color: Color

func _ready():
	for point in main.get_children_in_groups(self, ['point']):
		point.active_from = active_from
	deactivate()

func deactivate():
	for point in main.get_children_in_groups(self, ['point']):
		point.visible = false
		point.collider.disabled = true

	visible = false

func activate():
	for point in main.get_children_in_groups(self, ['point']):
		point.visible = true
		point.collider.disabled = false
		
	visible = true

	var belts = main.get_children_in_groups(self, ['belt'])
	if len(belts) == 0:
		var belt = main.create_node(belt_prefab, self)
		belt.global_position = Vector2.ZERO;
		belt.update([reciever_1.global_position, drop_1.global_position])
		belt.approve()

		belt = main.create_node(belt_prefab, self)
		belt.global_position = Vector2.ZERO;
		belt.update([reciever_2.global_position, drop_2.global_position])
		belt.approve()

		belt = main.create_node(belt_prefab, self)
		belt.global_position = Vector2.ZERO;
		belt.update([reciever_3.global_position, drop_3.global_position])
		belt.approve()

		belt = main.create_node(belt_prefab, self)
		belt.global_position = Vector2.ZERO;
		belt.update([reciever_4.global_position, drop_4.global_position])
		belt.approve()
