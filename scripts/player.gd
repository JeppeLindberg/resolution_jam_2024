extends Node2D

@export var belt_prefab: PackedScene

@onready var belts = get_node('/root/main/world/belts')
@onready var main = get_node('/root/main')

var _target_belt = null;
var _position_path = []
var _latest_position = Vector2.ZERO


func _process(_delta: float) -> void:
	if Input.is_action_pressed('speed_up'):
		main.delta_mult = 5.0
	else:
		main.delta_mult = 1.0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed) and (_position_path == []):
			_add_points_at(event.position)
			if _position_path != []:
				_target_belt = main.create_node(belt_prefab, belts)
				_update()

		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			_latest_position = Vector2.ZERO
			_update()
			_approve()
			_position_path = []
			_target_belt = null;

			var ui = main.get_nodes_at(event.position, ['ui']);
			if len(ui) > 0:
				ui[0].clicked()

		if (event.button_index == MOUSE_BUTTON_RIGHT) and (not event.pressed):
			var belts_clicked = main.get_nodes_at(event.position, ['belt']);
			if len(belts_clicked) > 0:
				belts_clicked[0].queue_free()
	
	if event is InputEventMouseMotion:
		_latest_position = event.position

		if _position_path != []:
			_add_points_at(event.position)
			_update()

func _add_points_at(pos):
	var nodes = main.get_nodes_at(pos, ['emitter', 'reciever']);
	for node in nodes:
		if node.visible and _position_path.find(node) == -1:
			_position_path.append(node.global_position)

func _update():
	if _target_belt == null:
		return
	
	var positions = []
	for pos in _position_path:
		positions.append(pos)
	if _latest_position != Vector2.ZERO:
		positions.append(_latest_position)

	_target_belt.update(positions)

func _approve():
	if _target_belt == null:
		return

	if len(_position_path) < 2:
		_target_belt.queue_free()
		return

	_target_belt.approve()

