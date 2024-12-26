extends Node2D

@onready var main = get_node('/root/main')

@export var active_from = 0
@export var inactive_from = 0

@export var reciever: Node2D
@export var emitter: Node2D
@export var belt_prefab: PackedScene


func _ready():
	for point in main.get_children_in_groups(self, ['point']):
		point.active_from = active_from
		point.inactive_from = inactive_from
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
		belt.update([reciever.global_position, emitter.global_position])
		belt.approve()
