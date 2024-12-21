extends Sprite2D

@onready var main = get_node('/root/main')

func _process(delta: float):
	self_modulate.a -= delta * main.delta_mult * 0.5
	if self_modulate.a <= 0:
		queue_free()
		return
