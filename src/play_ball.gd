extends Node2D


@onready var center_pos: Vector2 = $CenterMarker.position
@onready var pitcher_cursor: PitcherCursor = %PitcherCursor
@onready var strike_zone: StrikeZone = %StrikeZone
@onready var batter_circle: BatterCircle = %BatterCircle
@onready var hit_fairy: HitFairy = $HitFairy
@onready var label: Label = $UI/Panel/Label


func _ready() -> void:
	pitcher_cursor.position = center_pos
	batter_circle.position = center_pos
	pitcher_cursor.arrived.connect(func(shape): hit_fairy.rect_shape = shape)
	batter_circle.swung.connect(func(shape): hit_fairy.circ_shape = shape)
	hit_fairy.hit_percentage.connect(func(pc): label.text = "HIT: " + str(pc) + "%")
