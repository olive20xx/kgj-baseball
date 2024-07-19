class_name Rectangle2D
extends Node2D

var animating := false

@export var rect: Rect2
@export var color: Color = Color.LAVENDER
@export var filled := false
@export var border_width := 4

@onready var blink: Blink = $Blink


func _draw() -> void:
	draw_rect(rect, color, filled, border_width)


func _process(_delta: float) -> void:
	if animating:
		queue_redraw()


func start_blink(blink_dur: float, invis_dur: float, vis_dur: float) -> void:
	blink.blink_dur = blink_dur
	blink.invis_dur = invis_dur
	blink.vis_dur = vis_dur
	blink.start()


func stop_blink() -> void:
	blink.stop()