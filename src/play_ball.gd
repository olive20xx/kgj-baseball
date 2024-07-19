extends Node2D

## TODO:
# 1 - animate the strikezone square
# 2 - track swing timing
# 3 - make the sequence of play
# 4 - create 4 different pitches
# 5 - strike zone fun
#	   - random shapes
#      - moving strike zone!

var reset_time := 2.0

@onready var center_pos: Vector2 = $CenterMarker.position
@onready var pitcher_cursor: PitcherCursor = %PitcherCursor
@onready var strike_zone: StrikeZone = %StrikeZone
@onready var batter_circle: BatterCircle = %BatterCircle
@onready var hit_fairy: HitFairy = $HitFairy
@onready var label: Label = $UI/Panel/Label
@onready var reset_timer: Timer = $ResetTimer


func _ready() -> void:
	reset()
	pitcher_cursor.arrived.connect(hit_fairy.assign_rect)
	batter_circle.swung.connect(hit_fairy.assign_circ)
	hit_fairy.hit_percentage.connect(_on_pitch_complete)


func _on_pitch_complete(pc: float) -> void:
	label.text = "HIT: " + str(pc) + "%"
	reset_timer.start(reset_time)
	await reset_timer.timeout
	reset()


func reset() -> void:
	hit_fairy.reset()
	pitcher_cursor.position = center_pos
	batter_circle.position = center_pos
	pitcher_cursor.reset()
	pitcher_cursor.strike_zone_rect = strike_zone.rect
	pitcher_cursor.strike_zone_pos = strike_zone.position