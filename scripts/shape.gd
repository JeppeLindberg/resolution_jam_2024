extends Node2D

@onready var sprite = get_node('sprite')

func _ready() -> void:
	add_to_group('shape')

func recolor(new_color):
	sprite.self_modulate = new_color

