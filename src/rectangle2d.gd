class_name Rectangle2D
extends Line2D

signal animation_done(timestamp_ms: int)

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
var anim_duration: float
var target_scale: Vector2
var target_position: Vector2

@onready var blink: Blink = $Blink


func _ready() -> void:
	assert(points.size() == 4)
	default_color = Color.LAVENDER


func _process(delta: float) -> void:
	var position_delta := get_animation_delta(position, target_position, delta)
	var scale_delta := get_animation_delta(scale, target_scale, delta)
	if is_animating:
		elapsed_time += delta
		position = position.move_toward(target_position, position_delta)
		scale = scale.move_toward(target_scale, scale_delta)
	
	if is_animating and elapsed_time >= anim_duration:
		animation_done.emit(Time.get_ticks_msec())
		is_animating = false
		elapsed_time = 0.0


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


func set_target_scale(target_rect: Rect2) -> void:
	var scale_x := target_rect.size.x / (top_right.x - top_left.x)
	var scale_y := target_rect.size.y / (bot_left.y - top_left.y)
	target_scale = Vector2(scale_x, scale_y)


func reset() -> void:
	modulate.a = 1.0
	scale = Vector2.ONE
	hide()