class_name Rectangle2D
extends Node2D

@export var rect: Rect2
@export var color: Color = Color.LAVENDER
@export var filled := false
@export var border_width := 4


func _draw() -> void:
	draw_rect(rect, color, filled, border_width)
