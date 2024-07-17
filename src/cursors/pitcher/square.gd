class_name PitcherSquare
extends Node2D


const dist_to_tight = 120.0

@onready var top_left: Sprite2D = $TopLeft
@onready var top_right: Sprite2D = $TopRight
@onready var bot_left: Sprite2D = $BotLeft
@onready var bot_right: Sprite2D = $BotRight


func tighten_it_up_there_boys(time: float) -> Tween:
	var rads := deg_to_rad(45)
	var tween := create_tween().set_parallel()
	tween.tween_property(top_left, "position", Vector2.from_angle(rads) * dist_to_tight, time).as_relative()
	tween.tween_property(top_right, "position", Vector2.from_angle(3 * rads) * dist_to_tight, time).as_relative()
	tween.tween_property(bot_left, "position", Vector2.from_angle(-rads) * dist_to_tight, time).as_relative()
	tween.tween_property(bot_right, "position", Vector2.from_angle(-3 * rads) * dist_to_tight, time).as_relative()
	tween.play()
	return tween
