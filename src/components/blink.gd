class_name Blink
extends Node

@export var blinking_on_spawn := false
@export var blink_dur := 1.0 #pitching: start: 1.0, lowest 0.3
@export var invis_dur := 0.3 #pitching: start: 0.3, lowest 0.1
@export var vis_dur   := 0.1 #pitching: start: 0.1, highest: 0.25

@onready var parent: Node = get_parent()
var tween: Tween


func _ready() -> void:
	if blinking_on_spawn and parent:
		start_blink()


func start_blink():
	tween = create_tween()
	tween.bind_node(self)
	tween.set_loops()
	tween.tween_property(self, "parent:modulate:a", 0.0, blink_dur)
	tween.tween_interval(invis_dur)
	tween.tween_property(self, "parent:modulate:a", 1.0, blink_dur)
	tween.tween_interval(vis_dur)
	tween.play()

func stop_blink() -> void:
	tween.kill()
