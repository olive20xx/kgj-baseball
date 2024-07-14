class_name Dot
extends Sprite2D

# manually estimated, because node size != image size
const _DIAMETER = 14.0

var diameter := _DIAMETER * scale.x

func _ready() -> void:
	set_random_rotation()


func set_random_rotation() -> void:
	rotation_degrees = randf_range(-360, 360)
