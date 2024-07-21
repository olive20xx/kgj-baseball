class_name Rectangle2D
extends Line2D

@export var top_left: Vector2:
	get: return points[0]
	set(v): points[0] = v

@export var top_right: Vector2:
	get: return points[1]
	set(v): points[1] = v

@export var bot_right: Vector2:
	get: return points[2]
	set(v): points[2] = v
		
@export var bot_left: Vector2:
	get: return points[3]
	set(v): points[3] = v

var is_animating := false
var elapsed_time := 0.0
var anim_duration: float = 2.0
var target_scale: Vector2 = Vector2(0.6, 0.2)
var target_position: Vector2

@onready var blink: Blink = $Blink


func _ready() -> void:
	assert(points.size() == 4)
	default_color = Color.LAVENDER
	is_animating = true


func _process(delta: float) -> void:
	var position_delta := get_animation_delta(position, target_position, delta)
	var scale_delta := get_animation_delta(scale, target_scale, delta)
	if is_animating:
		elapsed_time += delta
		position = position.move_toward(target_position, position_delta)
		scale = scale.move_toward(target_scale, scale_delta)
		$Label.text = str(elapsed_time).pad_decimals(1) + "\n" + str(position) + "\n" + str(scale)
	
	if elapsed_time >= anim_duration:
		is_animating = false


func start_blink(blink_dur: float, invis_dur: float, vis_dur: float) -> void:
	blink.blink_dur = blink_dur
	blink.invis_dur = invis_dur
	blink.vis_dur = vis_dur
	blink.start()


func stop_blink() -> void:
	blink.stop()


func get_animation_delta(current: Variant, target: Variant, delta: float) -> float:
	var time_remaining := anim_duration - elapsed_time
	var remaining: float
	
	if current is Vector2:
		remaining = current.distance_to(target)
	else:
		remaining = target - current

	return remaining * delta / time_remaining


# func animate_to(target: Rect2, offset: Vector2, time: float) -> void:
# 	anim_duration = time
# 	var t_topleft  := offset + target.position
# 	var t_topright := offset + t_topleft + Vector2(target.size.x, 0)
# 	var t_botright := offset + t_topleft + target.size
# 	var t_botleft  := offset + t_topleft + Vector2(0, target.size.y)

# 	target_points = [t_topleft, t_topright, t_botright, t_botleft]

# 	is_animating = true
