class_name StrikeZone
extends Node2D

var topleft: Vector2:
	get: return Vector2(home_plate.left, batter.top)

var size: Vector2:
	get: return Vector2(home_plate.dist, batter.dist)

@onready var home_plate: HomePlate = $HomePlate
@onready var batter: Batter = $Batter


func _ready() -> void:
	var box := Rectangle2D.new()
	box.rect = Rect2(topleft, size)
	add_child(box)
