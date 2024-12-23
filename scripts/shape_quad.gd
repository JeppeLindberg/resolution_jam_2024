extends Node2D

var type = 'quad'

@export var move_size = 4.5
@export var mult_size = 0.5
@export var minus_size = 0.05

func _ready() -> void:
	add_to_group('shape')

func create_from(shapes):
	for shape in shapes:
		for sprite in shape.get_children():
			if not sprite is Sprite2D:
				continue

			var delta_vec = sprite.global_position - global_position
			var sprite_old_position = sprite.position
			sprite.reparent(self)
			sprite.position = sprite_old_position * 0.5

			if delta_vec.x < 0 and delta_vec.y < 0:
				sprite.position += Vector2(-1, -1) * move_size
			elif delta_vec.x < 0 and delta_vec.y > 0:
				sprite.position += Vector2(-1, 1) * move_size
			elif delta_vec.x > 0 and delta_vec.y < 0:
				sprite.position += Vector2(1, -1) * move_size
			elif delta_vec.x > 0 and delta_vec.y > 0:
				sprite.position += Vector2(1, 1) * move_size
			
			sprite.scale = Vector2(sprite.scale.x * mult_size - minus_size, sprite.scale.y * mult_size - minus_size)

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

