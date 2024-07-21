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

@onready var blink: Blink = $Blink


func _ready() -> void:
	assert(points.size() == 4)
	default_color = Color.LAVENDER


func start_blink(blink_dur: float, invis_dur: float, vis_dur: float) -> void:
	blink.blink_dur = blink_dur
	blink.invis_dur = invis_dur
	blink.vis_dur = vis_dur
	blink.start()


func stop_blink() -> void:
	blink.stop()
