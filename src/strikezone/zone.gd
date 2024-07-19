class_name StrikeZone
extends Node2D

@export var pitcher_cursor: PitcherCursor

var topleft: Vector2:
	get: return Vector2(home_plate.left, batter.top)

var size: Vector2:
	get: return Vector2(home_plate.dist, batter.dist)

@onready var home_plate: HomePlate = $HomePlate
@onready var batter: Batter = $Batter
@onready var arrival_rect: Rectangle2D = $Rectangle
@onready var rect := Rect2(topleft, size)
@onready var target_rect

func _ready() -> void:
	pitcher_cursor.pitching.connect(show_arrival_rect)
	pitcher_cursor.arrival_start.connect(animate_arrival_rect)


func show_arrival_rect() -> void:
	arrival_rect.rect = rect
	arrival_rect.position = Vector2.ZERO
	arrival_rect.border_width = 2
	arrival_rect.show()
	arrival_rect.start_blink(0.2, 0.05, 0.05)


func animate_arrival_rect() -> void:
	arrival_rect.stop_blink()
	arrival_rect.modulate.a = 0.6
	# move and scale to pitcher_square
