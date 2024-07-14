class_name HomePlate
extends Node2D

#MIN_DIST = 95(_left) + 95(_right)
#MIN_DIST = 190
const LEFT_X_START = 95.0
const DIST_START = LEFT_X_START * 2

var left: float:
	get: return _left.position.x
var right: float:
	get: return _right.position.x
var dist: float:
	get: return right - left

@onready var _left: Sprite2D = %Left
@onready var _right: Sprite2D = %Right


func set_dist(distance: int, ratio := 1.0) -> float:
	distance += DIST_START
	
	ratio = clampf(ratio, 0.0, 2.0)
	var isEven := distance % 2 == 0
	if not isEven:
		distance += 1
	
	var half := distance / 2
	_right.position.x = half * ratio
	_left.position.x = _right.position.x - distance
	
	return distance
