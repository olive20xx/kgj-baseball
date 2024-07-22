class_name HitFairy
extends Node2D

signal hit_percentage(value: int)

# TODO: I think you just need the global position and shape.radius
var batter_shape: CollisionShape2D  # circle
# TODO: I think you just need the global position and Rect2 (or position + size)
var pitcher_shape: CollisionShape2D # rect
var overlap: PackedVector2Array = []


func assign_rect(shape: CollisionShape2D) -> void:
	pitcher_shape = shape
	if batter_shape: get_overlap()

func assign_circ(shape: CollisionShape2D) -> void:
	batter_shape = shape
	position = batter_shape.global_position
	if pitcher_shape: get_overlap()


func get_overlap() -> void:
	if not batter_shape or not pitcher_shape:
		print("hit fairy missing a shape")
		print('circ: ', !!batter_shape, ' | rect: ', !!pitcher_shape)
		return

	# GlobalPosition (from center, absolute) + Rect2D.position (top-left, relative)
	var rect_pos := pitcher_shape.global_position + pitcher_shape.shape.get_rect().position
	# Since this node re-positions to the center of the Batter Circle, we can get
	# dist by using our GlobalPosition
	var dist_to_rect := rect_pos - global_position 
	
	var rect_polygon := make_rect_polygon(pitcher_shape.shape.get_rect(), dist_to_rect) 
	var circ_polygon := make_circle_polygon(batter_shape.shape.radius, 12)

	var overlap_result := Geometry2D.intersect_polygons(rect_polygon, circ_polygon)
	if not overlap_result.is_empty():
		overlap = overlap_result[0]
	
	var hit := calculate_hit_percentage()
	hit_percentage.emit(hit)
	queue_redraw()


func calculate_hit_percentage() -> int:
	var total: float
	var rect_area := pitcher_shape.shape.get_rect().get_area()
	var circ_area := PI * pow(batter_shape.shape.radius, 2)
	
	if rect_area < circ_area:
		total = rect_area
	else:
		total = circ_area
	
	var hit := calculate_area(overlap)
	
	return roundi(hit / total * 100)


func reset() -> void:
	batter_shape = null
	pitcher_shape = null
	overlap = []
	queue_redraw()


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
