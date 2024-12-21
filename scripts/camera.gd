extends Camera2D

@export_flags_2d_render var render_layers

var ui = null


func _ready():
	get_viewport().canvas_cull_mask = render_layers

func _process(_delta: float) -> void:
	if ui == null:
		ui = get_node_or_null('ui')
	
	if ui != null:
		ui.scale = Vector2(1.0 / zoom.x, 1.0 / zoom.y)


