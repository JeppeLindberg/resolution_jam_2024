extends Node2D

@onready var main = get_node('/root/main')
@onready var points = get_node('/root/main/world/points')
@onready var belts = get_node('/root/main/world/belts')

@export var max_time: float = 60.0
var max_time_dict: Dictionary = {
	0: -1.0,
	1: 120.0,
	2: 60.0,
	3: 90.0,
	4: 90.0,
	5: 120.0,
	6: -1.0
}
@export var time: float = 60.0
@export var timer_running = true
@export var timed_out = false

@export var current_stage = -1

@export var timer: Node2D
@export var continue_button: Node2D
@export var time_out: Node2D


func _ready() -> void:
	next_stage()

func _process(delta):
	if timer_running:
		time -= delta * main.delta_mult
		timer.timer = time / max_time
		timer.visible = time > 0.0
	if max_time == -1.0:
		time = 1.0
		timer.timer = 1.0
		timer.visible = true

	if timer_running == true:
		_check_continue()
	if timer_running == true:
		_check_time_out()

func _check_continue():
	for consumer in main.get_children_in_groups(points, ['consumer'], true):
		if consumer.visible and consumer.current_inventory != consumer.max_inventory:
			return
	
	timer_running = false
	continue_button.activate()

func _check_time_out():
	if time <= 0.0:
		timer_running = false
		timed_out = true
		time_out.activate()

func next_stage():
	current_stage += 1;
	print('current stage: ' + str(current_stage))

	for vehicle in main.get_children_in_groups(main, ['vehicle'], true):
		vehicle.queue_free()
	for point in main.get_children_in_groups(points, ['point'], true):
		if point.inactive_from <= current_stage:
			point.deactivate()
		elif point.active_from <= current_stage:
			point.activate()
		for buffer_holder in main.get_children_in_groups(point, ['buffer_holder'], true):
			buffer_holder.queue_free()
	for belt in main.get_children_in_groups(belts, ['belt'], true):
		belt.queue_free()

	continue_button.deactivate()
	time_out.deactivate()

	if max_time_dict.has(current_stage):
		max_time = max_time_dict[current_stage]

	time = max_time
	timer_running = true
	timed_out = false
