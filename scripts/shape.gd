extends Node2D

@onready var sprite = get_node('sprite')

func _ready() -> void:
	add_to_group('shape')

func recolor(new_color):
	sprite.self_modulate = new_color

func matches(shape):
	if sprite.self_modulate != shape.sprite.self_modulate:
		return(false)
	return(true)

