extends PathFollow2D



func _process(delta: float) -> void:
	var prev_progress = progress
	progress += delta * 100.0
	if progress < prev_progress:
		print('bla')
		queue_free()
