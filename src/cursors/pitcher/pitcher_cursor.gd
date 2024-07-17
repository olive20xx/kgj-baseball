class_name PitcherCursor
extends Node2D

signal arrived(shape: CollisionShape2D)

#pitch needs: time_to_arrive, move_range

var accept_input := true

@onready var move = $Move
@onready var pitcher_square: PitcherSquare = $Square
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D


func _input(event: InputEvent) -> void:
	if not accept_input:
		return
	
	if event.is_action_pressed("throw"):
		pitch()


func pitch(speed: float = 10) -> void:
	#freeze
	accept_input = false
	#call square with pitch speed
	var tween := pitcher_square.tighten_it_up_there_boys(0.5)
	await tween.finished
	arrived.emit(collision_shape)
	


func animate_square() -> void:
	pass
