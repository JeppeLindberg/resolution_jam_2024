extends Node2D

@onready var main = get_node('/root/main')
@onready var points = get_node('/root/main/world/points')
@onready var belts = get_node('/root/main/world/belts')

@export var max_time: float = 60.0
@export var time: float = 60.0
@export var timer_running = true
@export var ready_for_continue = false

@export var current_stage = -1

@export var timer: Node2D
@export var continue_button: Node2D


func _ready() -> void:
	next_stage()

func _process(delta):
	if timer_running:
		time -= delta * main.delta_mult
	timer.timer = time / max_time

	for consumer in main.get_children_in_groups(points, ['consumer'], true):
		if consumer.visible and consumer.current_inventory != consumer.max_inventory:
			return
	
	timer_running = false
	if not ready_for_continue:
		ready_for_continue = true
		continue_button.activate()

func next_stage():
	current_stage += 1;
	print('current stage: ' + str(current_stage))

	for vehicle in main.get_children_in_groups(belts, ['vehicle'], true):
		vehicle.queue_free()
	for point in main.get_children_in_groups(points, ['point'], true):
		if point.inactive_from <= current_stage:
			point.deactivate()
		elif point.active_from <= current_stage:
			point.activate()
	for belt in main.get_children_in_groups(belts, ['belt'], true):
		belt.check_cull()

	continue_button.deactivate()
	time = max_time
	timer_running = true
	ready_for_continue = false
