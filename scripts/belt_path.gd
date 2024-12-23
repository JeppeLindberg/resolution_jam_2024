extends Path2D

@onready var main = get_node('/root/main')

@export var collider_prefab: PackedScene
@export var speed_mult = 1.0


func _ready() -> void:
	add_to_group('path')

func _process(delta: float) -> void:
	var vehicles = main.get_children_in_groups(self, ['vehicle'])
	vehicles.sort_custom(progress_desc)
	var max_progress = 99999.0
	for vehicle in vehicles:
		vehicle.commit_progress(delta, max_progress)
		max_progress = vehicle.progress - 30.0

func has_space_at(pos):
	if curve.point_count == 0:
		return(false)

	if curve.get_point_position(0) != pos:
		return(false)

	for child in main.get_children_in_groups(self, ['vehicle']):
		if child.progress < 30.0:
			return(false)
			
	return(true)

func add_new_shape(shape_prefab):
	var new_vehicle = main.create_node(main.vehicle_prefab, self)
	new_vehicle.global_position = curve.get_point_position(0)
	new_vehicle.set_new_shape(shape_prefab)
	return(new_vehicle)

func add_shape(shape):
	var new_vehicle = main.create_node(main.vehicle_prefab, self)
	new_vehicle.global_position = curve.get_point_position(0)
	new_vehicle.set_shape(shape)
	return(new_vehicle)

func approve():
	var new_curve = Curve2D.new()
	new_curve.bake_interval = 1.0

	for point in get_parent().points:
		new_curve.add_point(point)
	
	curve = new_curve

	var new_nodes = add_node_along_path(collider_prefab, 20.0)
	for node in new_nodes:
		var collision_shape = node.get_node('collider')
		var body = self
		while not body is StaticBody2D:
			body = body.get_parent()
		collision_shape.reparent(body)
		node.queue_free()

func add_node_along_path(node_prefab, interval):
	var prev_progress = 0.0
	var new_node = null
	var new_nodes = []
	while new_node == null or new_node.progress > prev_progress:
		if new_node != null:
			prev_progress = new_node.progress
	
		new_node = main.create_node(node_prefab, self)
		new_node.progress = prev_progress
		new_node.progress += interval
		new_nodes.append(new_node)

	if len(new_nodes) > 0:
		new_nodes[len(new_nodes)-1].queue_free()
		new_nodes.pop_back()

	return(new_nodes)
	
func progress_desc(a, b): 
	return a.progress > b.progress
