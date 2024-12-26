extends Node2D

@onready var main = get_node('/root/main')
@onready var game = get_node('/root/main/game')


func _process(_delta: float) -> void:
	for child in get_children():
		child.visible = false

	if not game.timer_running:
		return

	var tutorial = get_node_or_null(str(game.current_stage))
	if tutorial != null:
		tutorial.visible = true
