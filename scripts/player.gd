extends Node2D

@export var belt_prefab: PackedScene

@onready var belts = get_node('/root/main/world/belts')
@onready var main = get_node('/root/main')

var _target_belt = null;
var _point_path = []
var _latest_position = Vector2.ZERO


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed) and (_point_path == []):
			_target_belt = main.create_node(belt_prefab, belts)
			_add_points_at(event.position)
			_update()

		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			_latest_position = Vector2.ZERO
			_update()
			_approve()
			_point_path = []
			_target_belt = null;
	
	if event is InputEventMouseMotion:
		_latest_position = event.position

		if _point_path != []:
			_add_points_at(event.position)
			_update()

func _add_points_at(pos):
	var nodes = main.get_nodes_at(pos);
	for node in nodes:
		if _point_path.find(node) == -1:
			_point_path.append(node)

func _update():
	if _target_belt == null:
		return
	
	var positions = []
	for point in _point_path:
		positions.append(point.global_position)
	if _latest_position != Vector2.ZERO:
		positions.append(_latest_position)

	_target_belt.update(positions)

func _approve():
	if _target_belt == null:
		return

	if len(_point_path) < 2:
		_target_belt.queue_free()
		return

	_target_belt.approve()

