class_name StrikeZone
extends Node2D

@export var pitcher_cursor: PitcherCursor

var top_left: Vector2:
	get: return Vector2(home_plate.left, batter.top)

var top_right: Vector2:
	get: return Vector2(home_plate.right, batter.top)

var bot_right: Vector2:
	get: return Vector2(home_plate.right, batter.bot)

var bot_left: Vector2:
	get: return Vector2(home_plate.left, batter.bot)

@onready var home_plate: HomePlate = $HomePlate
@onready var batter: Batter = $Batter
@onready var rectangle: Rectangle2D = $Rectangle


func _ready() -> void:
	if pitcher_cursor:
		pitcher_cursor.pitching.connect(show_arrival_rect)
		pitcher_cursor.arrival_start.connect(animate_arrival_rect)


func _process(_delta: float) -> void:
	if rectangle.is_animating:
		rectangle.target_position = pitcher_cursor.position


func show_arrival_rect() -> void:
	rectangle.top_left = top_left
	rectangle.top_right = top_right
	rectangle.bot_right = bot_right
	rectangle.bot_left = bot_left
	rectangle.position = Vector2.ZERO
	rectangle.width = 2
	rectangle.show()
	rectangle.start_blink(0.2, 0.05, 0.05)


func animate_arrival_rect(time: float) -> void:
	rectangle.anim_duration = time
	rectangle.stop_blink()
	rectangle.modulate.a = 0.6
	# move and scale to pitcher_square
	rectangle.set_target_scale(pitcher_cursor.get_target_rect())
	# rectangle.target_position is updated continuously in _process
	rectangle.is_animating = true


func reset() -> void:
	rectangle.reset()