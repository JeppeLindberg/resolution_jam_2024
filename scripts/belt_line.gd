extends Line2D

@onready var main = get_node('/root/main')
@onready var path = get_node('path')

var recreate = false

func _ready() -> void:
	recreate = true;

func _process(_delta: float) -> void:
	_recreate()

func _recreate():
	if not recreate:
		return

	var relays = main.get_children_in_groups(get_parent(), ['relay'])
	var main_points = []

	for relay in relays:
		if not relay.is_queued_for_deletion():
			main_points.append(relay.global_position - global_position)

	var new_points = []

	for i in range(len(main_points) - 1):
		var point_1 = main_points[i]
		var point_4 = main_points[i + 1]

		var mid_point = lerp(point_1, point_4, 0.5)

		var towards_point_4 = Vector2.LEFT
		if abs(point_1.x - point_4.x) < abs(point_1.y - point_4.y):
			towards_point_4 = Vector2.DOWN

		var rectangle_points = [Geometry2D.line_intersects_line(point_1, towards_point_4, mid_point, Vector2(-1, 1)),
								Geometry2D.line_intersects_line(point_1, towards_point_4, mid_point, Vector2(1, 1)),
								Geometry2D.line_intersects_line(point_4, -towards_point_4, mid_point, Vector2(-1, 1)),
								Geometry2D.line_intersects_line(point_4, -towards_point_4, mid_point, Vector2(1, 1))]

		_target_point = point_1
		rectangle_points.sort_custom(closeness_ascending)

		var point_2 = rectangle_points[0]
		var point_3 = rectangle_points[3]

		for point in [point_1, point_2, point_3, point_4]:
			if new_points.find(point) == -1:
				new_points.append(point)

	points = PackedVector2Array(new_points)

	recreate = false

var _target_point = Vector2.ZERO
func closeness_ascending(a, b): 
	return a.distance_to(_target_point) < b.distance_to(_target_point)

func approve():
	_recreate()
	path.approve()

