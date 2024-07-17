class_name BatterCircle
extends Node2D

signal swung(shape: CollisionShape2D)

const dot_scene = preload("res://src/cursors/dot.tscn")

#TODO: remove enum selector after dev
enum SIZES {
	SMALL,
	NORMAL,
	BIG,
	HUGE,
}
const Sizes = {
	SIZES.SMALL: { "radius": 28, "gap": 5.0 },
	SIZES.NORMAL: { "radius": 40, "gap": 5.0 },
	SIZES.BIG: { "radius": 52, "gap": 6.0 },
	SIZES.HUGE: { "radius": 70, "gap": 10.0 },
}
@export var size := SIZES.NORMAL
@onready var _size = Sizes[size] as Dictionary

var accept_input := true

var yellow := Color("fff314")
var red := Color("ff3014")
@export_category("Swing")
@export var reset_time := 0.5
@export var spin_deg := 30.0
@export var spin_dur := 0.2
@export var spin_scale := 0.9
var tween: Tween

@onready var dots: Node2D = $Dots
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer: Timer = $Timer
@onready var move: Move = $Move


func _ready() -> void:
	collision_shape.shape.radius = _size.radius * spin_scale
	move.speed = 180.0
	render()


func _input(event: InputEvent) -> void:
	if accept_input and event.is_action_pressed("ui_accept"):
		swing()


func swing() -> void:
	accept_input = false
	var swing := animate_swing()
	await swing.finished
	swung.emit(collision_shape)
	
	await get_tree().create_timer(reset_time).timeout
	var reset := animate_reset()
	await reset.finished
	accept_input = true


func animate_swing() -> Tween:
	if tween:
		tween.kill()
	
	var tween := create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	tween.bind_node(dots)
	tween.tween_property(dots, "rotation_degrees", spin_deg, spin_dur).as_relative()
	tween.tween_property(dots, "scale", Vector2.ONE * spin_scale, spin_dur)
	tween.tween_property(dots, "modulate", red, spin_dur)
	tween.play()
	return tween


func animate_reset() -> Tween:
	if tween:
		tween.kill()
	
	tween = create_tween().set_parallel()
	tween.tween_property(dots, "rotation_degrees", -spin_deg, 0.2).as_relative()
	tween.tween_property(dots, "scale", Vector2.ONE, 0.2)
	tween.tween_property(dots, "modulate", yellow, 0.2)
	tween.play()
	
	return tween

# TODO: needs work
func render() -> void:
	# get circumference
	var circumf := 2 * PI * _size.radius as int
	
	# count dots + gap
	var dot: Dot = dot_scene.instantiate()
	dot.position.y = _size.radius
	var length := dot.diameter + _size.gap as float
	var dot_count := floori(circumf / length)
	
	# evenly space dots around circle
	# this part seems a lil incorrect...
	var degree_spacing := floori(360 / dot_count)
	
	for i in dot_count:
		var degrees := degree_spacing * i
		var pos := Vector2.ZERO
		# x = radius * cos(angle)
		# y = radius * sin(angle) 
		pos.x = _size.radius * cos(deg_to_rad(degrees))
		pos.y = _size.radius * sin(deg_to_rad(degrees))
		var new_dot: Dot = dot_scene.instantiate()
		new_dot.position = pos
		dots.add_child(new_dot)
