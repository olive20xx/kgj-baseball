extends Node2D

@onready var circle_shape: CollisionShape2D = $CircleArea/CollisionShape2D
@onready var rect_shape: CollisionShape2D = $RectArea/CollisionShape2D

var rect_polygon: PackedVector2Array = []
var circle_polygon: PackedVector2Array = []
var overlap = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing"):
		rect_polygon = make_rect_polygon(rect_shape.shape.get_rect(), rect_shape.global_position - circle_shape.global_position)
		circle_polygon = make_circle_polygon(10, 12)
		overlap = get_overlap(rect_polygon, circle_polygon)
		print(overlap)
		queue_redraw()


func _draw() -> void:
	if rect_polygon:
		draw_polygon(rect_polygon, [Color.RED, Color.RED, Color.RED, Color.RED])
	if circle_polygon:
		var colors: PackedColorArray
		colors.resize(circle_polygon.size())
		colors.fill(Color.YELLOW)
		draw_polygon(circle_polygon, colors)
	if overlap:
		var colors: PackedColorArray
		colors.resize(overlap.size())
		colors.fill(Color.BLUE)
		draw_polygon(overlap[0], colors)


func get_overlap(poly1: PackedVector2Array, poly2: PackedVector2Array) -> Array[PackedVector2Array]:
	print(poly1)
	print(poly2)
	return Geometry2D.intersect_polygons(poly1, poly2)


func make_rect_polygon(rect: Rect2, pos: Vector2) -> PackedVector2Array:
	var polygon: PackedVector2Array = []
	var start := pos + rect.position
	var x_length := rect.size.x
	var y_length := rect.size.y
	
	polygon.append(start)
	polygon.append(start + Vector2(x_length, 0))
	polygon.append(start + rect.size)
	polygon.append(start + Vector2(0, y_length))
	
	return polygon


func make_circle_polygon(radius: float, num_sides: int) -> PackedVector2Array:
	var polygon: PackedVector2Array = []
	var angle_delta := (PI * 2) / num_sides
	var vector := Vector2(radius, 0)
	
	for _i in num_sides:
		polygon.append(vector)
		vector = vector.rotated(angle_delta)
	
	return polygon

var test: Array[String]
func hello() -> PackedVector2Array:
	var test2: Array[PackedVector2Array]
	var test1: PackedVector2Array
	test2 = test1
	return test
