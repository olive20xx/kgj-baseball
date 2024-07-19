class_name Move
extends Node

#TODO: parameterize the input map

@export var speed := 200.0

@export_category("InputMap")
@export var _left: String
@export var _right: String
@export var _up: String
@export var _down: String

@onready var parent: Node2D = get_parent()


var tween: Tween:
	set(t):
		if tween: tween.kill()
		tween = t

func _ready() -> void:
	assert(parent.get("accept_input") != null)
	assert_multiple([_left, _right, _up, _down])


func _process(delta: float) -> void:
	if parent.accept_input:
		move(delta)


func move(delta) -> void:
	var move_vec := Vector2.ZERO
	move_vec.x = Input.get_axis(_left, _right)
	move_vec.y = Input.get_axis(_up, _down)
	parent.position += move_vec.normalized() * speed * delta


func assert_multiple(variables: Array) -> void:
	for v in variables:
		assert(v)


func set_limited_move(initial_speed: float, time: float) -> Tween:
	speed = initial_speed
	tween = create_tween()
	tween.tween_property(self, "speed", 0, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.play()
	return tween