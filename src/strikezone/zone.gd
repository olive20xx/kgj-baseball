class_name StrikeZone
extends Node2D

@export var pitcher_cursor: PitcherCursor

var arrival_rect_moving := false

var topleft: Vector2:
	get: return Vector2(home_plate.left, batter.top)

var size: Vector2:
	get: return Vector2(home_plate.dist, batter.dist)

@onready var home_plate: HomePlate = $HomePlate
@onready var batter: Batter = $Batter
@onready var arrival_rect: Rectangle2D = $Rectangle
@onready var rect := Rect2(topleft, size)
@onready var target_rect: Rect2 = pitcher_cursor.collision_shape.shape.get_rect()
@onready var arrival_scale := Vector2(target_rect.size.x / size.x, target_rect.size.y / size.y)

var moving := false
var elapsed_time := 0.0
var arrival_time: float

func _ready() -> void:
	pitcher_cursor.pitching.connect(show_arrival_rect)
	pitcher_cursor.arrival_start.connect(animate_arrival_rect)

#TODO: THERE'S NO WAY TO DO THIS EXCEPT TO LERP THE FOUR CORNERS OF THE RECT >>>___<<<
func _process(delta: float) -> void:
	if moving:
		elapsed_time += delta
		var t := clampf(elapsed_time / arrival_time, 0.0, 1.0)
		#TODO: add collision shape offset
		arrival_rect.position = arrival_rect.position.lerp(pitcher_cursor.position, t)
	if elapsed_time >= arrival_time:
		moving = false



func show_arrival_rect() -> void:
	arrival_rect.rect = rect
	arrival_rect.position = Vector2.ZERO
	arrival_rect.border_width = 2
	arrival_rect.show()
	arrival_rect.start_blink(0.2, 0.05, 0.05)


func animate_arrival_rect(time: float) -> void:
	arrival_time = time
	arrival_rect.stop_blink()
	arrival_rect.modulate.a = 0.6
	# arrival_rect.position = pitcher_cursor.position
	# move and scale to pitcher_square
	moving = true
	var tween := create_tween().set_parallel()
	tween.tween_property(arrival_rect, "scale", arrival_scale, time)
	# tween.tween_property(arrival_rect, "position", pitcher_cursor.position, time)
	tween.play()


func get_target_rect() -> Rect2:
	return pitcher_cursor.collision_shape.shape.get_rect()
