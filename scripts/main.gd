extends Node

@export var world: Node2D

var _result


# Get all children of the node that belongs to all of the given groups
func get_children_in_groups(node, groups, recursive = false):
	_result = []

	if recursive:
		_get_children_in_groups_recursive(node, groups)
		return _result

	for child in node.get_children():
		for group in groups:				
			if child.is_in_group(group):
				_result.append(child)
				break

	return _result

# Get all children of the node that belongs to all of the given groups
func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		var add_to_result = true;
		for group in groups:
			if not child.is_in_group(group):
				add_to_result = false;
				break
				
		if add_to_result:
			_result.append(child)

		_get_children_in_groups_recursive(child, groups)

func create_node(prefab, parent):
	var new_node = prefab.instantiate()
	parent.add_child(new_node)
	return new_node

func get_nodes_at(pos, group = '', collision_mask = 0):
	var point:PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	point.position = pos;
	point.collide_with_areas = true
	if collision_mask != 0:
		point.collision_mask = collision_mask
	var collisions = world.get_world_2d().direct_space_state.intersect_point(point);
	if collisions == null:
		return([])
	
	var nodes = []
	for collision in collisions:
		var node = collision['collider'];
		if (group == '') or node.is_in_group(group):
			nodes.append(node)
	return nodes