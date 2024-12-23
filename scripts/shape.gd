extends Node2D

@onready var sprite = get_node('sprite')
var type = 'single'

func _ready() -> void:
	add_to_group('shape')

func recolor(new_color):
	sprite.self_modulate = new_color

func matches(shape):
	if type != shape.type:
		return(false)
		
	if sprite.self_modulate != shape.sprite.self_modulate:
		return(false)

	return(true)

