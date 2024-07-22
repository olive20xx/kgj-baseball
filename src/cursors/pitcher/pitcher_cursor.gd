class_name PitcherCursor
extends Node2D

signal arrived(shape: CollisionShape2D)
signal arrival_start(time: float)
signal pitching

var pitches := {
	"fastball": {
		"drift_speed": 100.0,
		"time_to_arrive": 0.5,
	},
	"curveball": {
		"drift_speed": 300.0,
		"time_to_arrive": 1.0,
	},
	"changeup": {
		"drift_speed": 300.0,
		"time_to_arrive": 1.5,
	},
}

var selected_pitch: Dictionary = pitches.curveball

var accept_input := true

@onready var move: Move = $Move
@onready var pitcher_square: PitcherSquare = $Square
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var crosshair: Sprite2D = $Crosshair
@onready var crosshair_blink: Blink = $Crosshair/Blink


func _input(event: InputEvent) -> void:
	if not accept_input:
		return
	
	if event.is_action_pressed("throw"):
		pitch()


func pitch() -> void:
	var drift_speed: float = selected_pitch.drift_speed
	var time_to_arrive: float = selected_pitch.time_to_arrive
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
	arrival_start.emit(time_to_arrive)
	crosshair.modulate.a = 0.0
	var tween := pitcher_square.tighten_it_up_there_boys()
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


func get_target_rect() -> Rect2:
	return collision_shape.shape.get_rect()