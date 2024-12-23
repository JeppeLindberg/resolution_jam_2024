extends Node2D

var type = 'quad'

@export var size = 10.0

func _ready() -> void:
	add_to_group('shape')

func create_from(shapes):
	var avg_position = Vector2.ZERO
	for shape in shapes:
		avg_position += shape.sprite.global_position
	avg_position /= len(shapes)

	for shape in shapes:
		var sprite = shape.sprite
		var delta_vec = sprite.global_position - avg_position

		sprite.reparent(self)

		if delta_vec.x < 0 and delta_vec.y < 0:
			sprite.position = Vector2(-1, -1) * size
		elif delta_vec.x < 0 and delta_vec.y > 0:
			sprite.position = Vector2(-1, 1) * size
		elif delta_vec.x > 0 and delta_vec.y < 0:
			sprite.position = Vector2(1, -1) * size
		elif delta_vec.x > 0 and delta_vec.y > 0:
			sprite.position = Vector2(1, 1) * size

func recolor(new_color):
	for child in get_children():
		if child is Sprite2D:
			child.self_modulate = new_color

func matches(shape):
	if type != shape.type:
		return(false)

	var self_sprites = get_children()
	var other_sprites = shape.get_children()

	if len(self_sprites) != len(other_sprites):
		return(false)

	self_sprites.sort_custom(positon_x_desc)
	other_sprites.sort_custom(positon_x_desc)

	for i in range(len(self_sprites)):
		if self_sprites[i].position != other_sprites[i].position:
			return(false)
		if self_sprites[i].self_modulate != other_sprites[i].self_modulate:
			return(false)
		
	return(true)

func positon_x_desc(a, b):
	if a.position.x == b.position.x:
		return a.position.y < b.position.y
	else:
		return a.position.x < b.position.x

