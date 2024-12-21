extends Node2D

@export var timer: float = 1.0

@onready var _progress_1 = get_node('progress_1')
@onready var _progress_2 = get_node('progress_2')
@onready var _pivot_1 = get_node('progress_1/pivot')
@onready var _pivot_2 = get_node('progress_2/pivot')

func _ready() -> void:
	visible = true;

func _process(_delta: float) -> void:
	if 0.5 < timer and timer <= 1.0:
		_progress_1.visible = true
		_progress_2.visible = false
		_pivot_1.rotation_degrees = 360.0 * (1.0 - timer)
	else:
		_progress_1.visible = false
		_progress_2.visible = true
		_pivot_2.rotation_degrees = 360.0 * (1.0 - timer) - 180.0

