extends StaticBody2D

@onready var game = get_node('/root/main/game')
@onready var collider = get_node('collider')


func _ready() -> void:
	add_to_group('ui')

func activate():
	visible = true
	collider.disabled = false

func deactivate():
	if collider == null:
		collider = get_node('collider')
		
	visible = false
	collider.disabled = true

func clicked():
	game.current_stage -= 1
	game.next_stage()
