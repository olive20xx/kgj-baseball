class_name HitFairy
extends Node2D

signal hit_percentage(value: int)

# TODO: I think you just need the global position and shape.radius
var circ_shape: CollisionShape2D:
	set(shape):
		circ_shape = shape
		position = circ_shape.global_position
		if rect_shape: get_overlap()
# TODO: I think you just need the global position and Rect2 (or position + size)
var rect_shape: CollisionShape2D:
	set(shape):
		rect_shape = shape
		if circ_shape: get_overlap()
var overlap: PackedVector2Array = []


func get_overlap() -> void:
	if not circ_shape or not rect_shape:
		print("hit fairy missing a shape")
		return

	# GlobalPosition (from center, absolute) + Rect2D.position (top-left, relative)
	var rect_pos := rect_shape.global_position + rect_shape.shape.get_rect().position
	# Since this node re-positions to the center of the Batter Circle, we can get
	# dist by using our GlobalPosition
	var dist_to_rect := rect_pos - global_position 
	
	var rect_polygon := make_rect_polygon(rect_shape.shape.get_rect(), dist_to_rect) 
	var circ_polygon := make_circle_polygon(circ_shape.shape.radius, 12)

	var overlap_result := Geometry2D.intersect_polygons(rect_polygon, circ_polygon)
	if not overlap_result.is_empty():
		overlap = overlap_result[0]
	
	var hit := calculate_hit_percentage()
	hit_percentage.emit(hit)
	queue_redraw()


func calculate_hit_percentage() -> int:
	var total: float
	var rect_area := rect_shape.shape.get_rect().get_area()
	var circ_area := PI * pow(circ_shape.shape.radius, 2)
	
	if rect_area < circ_area:
		total = rect_area
	else:
		total = circ_area
	#total := rect_shape.shape.get_rect().get_area()
	
	
	var hit := calculate_area(overlap)
	
	return roundi(hit / total * 100)


func clear() -> void:
	overlap = []
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): clear()

func _draw() -> void:
	if overlap:
		var colors := make_color_array(overlap.size(), Color.RED)
		draw_polygon(overlap, colors)


func make_color_array(size: int, color: Color) -> PackedColorArray:
		var colors: PackedColorArray
		colors.resize(size)
		colors.fill(color)
		return colors


func make_rect_polygon(rect: Rect2, pos := Vector2.ZERO) -> PackedVector2Array:
	var polygon: PackedVector2Array = []
	var start := pos #+ rect.position
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


func calculate_area(polygon: PackedVector2Array) -> float:
	var area := 0.0
	var j := polygon.size() - 1
	
	for i in polygon.size():
		area += (polygon[j].x + polygon[i].x) * (polygon[j].y - polygon[i].y)
		j = i
	
	return abs(area / 2)
# Thank you Math Open Reference!
# https://www.mathopenref.com/coordpolygonarea2.html
