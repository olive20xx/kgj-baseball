extends Node2D

@onready var center_pos: Vector2 = $CenterMarker.position
@onready var pitcher_cursor: Sprite2D = %PitcherCursor
@onready var strike_zone: StrikeZone = %StrikeZone
@onready var batter_circle: BatterCircle = %BatterCircle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pitcher_cursor.position = center_pos
	batter_circle.position = center_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
