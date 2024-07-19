class_name PitcherCursor
extends Node2D

signal arrived(shape: CollisionShape2D)
signal arrival_start
signal pitching

var accept_input := true

@onready var arrival_rect: Rectangle2D = $Rectangle
@onready var move: Move = $Move
@onready var pitcher_square: PitcherSquare = $Square
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var crosshair: Sprite2D = $Crosshair
@onready var crosshair_blink: Blink = $Crosshair/Blink
# A rectangle that starts as the strike zone, then zooms and moves in
# until it matches the final position of the square
# After pitching, it faintly grows back in the direction of the strike zone 
# but fades before it gets there


func _input(event: InputEvent) -> void:
	if not accept_input:
		return
	
	if event.is_action_pressed("throw"):
		pitch(100, 1)


func pitch(drift_speed: float, time_to_arrive: float) -> void:
	pitching.emit()
	#freeze
	accept_input = false
	# bring in square
	var fade_anim := pitcher_square.fade_in(0.2)
	await fade_anim.finished
	# show crosshair
	crosshair_blink.stop()
	crosshair.modulate.a = 1.0
	await get_tree().create_timer(0.5).timeout
	# narrow square
	arrival_start.emit()
	crosshair.modulate.a = 0.0
	var time_to_tight := 0.5
	var tween := pitcher_square.tighten_it_up_there_boys(time_to_tight)
	await tween.finished
	# allow limited movement after the throw
	accept_input = true
	var move_tween := move.set_limited_move(drift_speed, time_to_arrive)
	await move_tween.finished
	arrived.emit(collision_shape)


func reset() -> void:
	position = Vector2.ZERO
	accept_input = true
	crosshair_blink.reset()
	move.reset()
	pitcher_square.reset()
