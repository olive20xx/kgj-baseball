class_name PitcherSquare
extends Node2D


const dist_to_tight = 120.0

@onready var top_left: Sprite2D = $TopLeft
@onready var top_right: Sprite2D = $TopRight
@onready var bot_left: Sprite2D = $BotLeft
@onready var bot_right: Sprite2D = $BotRight

@onready var original_positions: Array[Vector2]
@onready var tight_positions: Array[Vector2]

var tween: Tween:
	set(t):
		if tween: tween.kill()
		tween = t


func _ready() -> void:
	for sprite in get_children():
		original_positions.append(sprite.position)
	reset()


func fade_in(time: float) -> Tween:
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, time).set_ease(Tween.EASE_IN)
	tween.play()
	return tween


func tighten_it_up_there_boys(time: float) -> Tween:
	var rads := deg_to_rad(45)
	tween = create_tween().set_parallel()
	tween.tween_property(top_left, "position", Vector2.from_angle(rads) * dist_to_tight, time).as_relative()
	tween.tween_property(top_right, "position", Vector2.from_angle(3 * rads) * dist_to_tight, time).as_relative()
	tween.tween_property(bot_left, "position", Vector2.from_angle(-rads) * dist_to_tight, time).as_relative()
	tween.tween_property(bot_right, "position", Vector2.from_angle(-3 * rads) * dist_to_tight, time).as_relative()
	tween.play()
	return tween


func reset() -> void:
	show()
	modulate.a = 0
	for i in original_positions.size():
		get_child(i).position = original_positions[i]