class_name PitcherCursor
extends Sprite2D


@onready var move = $Move

var accept_input := true

func _ready() -> void:
	print('parent ready')
