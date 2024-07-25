extends Node

## TODO:
# 0 - fix the strike zone
# 1 - balls and strikes
# 2 - track score
# 3 - make tutorial images
# 4 - baseball font

# post MVP
# - pitches with different X and Y drifts
# - add an actual baseball?? (for clarity)
# - pitcher fatigue
# - strike zone fun
#	   - random shapes
#      - moving strike zone!

var reset_time := 2.0

@onready var center_pos: Vector2 = $CenterMarker.position
@onready var pitcher_cursor: PitcherCursor = %PitcherCursor
@onready var strike_zone: StrikeZone = %StrikeZone
@onready var batter_circle: BatterCircle = %BatterCircle
@onready var hit_fairy: HitFairy = %HitFairy
@onready var label: Label = $UI/Panel/Label
@onready var reset_timer: Timer = $ResetTimer


func _ready() -> void:
	batter_circle.position = center_pos
	reset()
	pitcher_cursor.pitching.connect(func(): batter_circle.can_reset = false)
	pitcher_cursor.arrived.connect(hit_fairy.pitch_arrived)
	batter_circle.swung.connect(hit_fairy.batter_swung)
	batter_circle.swinging.connect(func(is_swinging): pitcher_cursor.is_batter_swinging = is_swinging)
	strike_zone.rectangle.animation_done.connect(func(ms): hit_fairy.pitch_timing = ms)
	hit_fairy.hit_percentage.connect(_on_pitch_complete)
	hit_fairy.miss.connect(_on_miss)


func _on_pitch_complete(pc: float) -> void:
	label.text = "HIT: " + str(pc) + "%"
	reset_timer.start(reset_time)
	await reset_timer.timeout
	reset()


func _on_miss() -> void:
	label.text = "MISS"
	reset()


func reset() -> void:
	var batter_reset_time := 0.4
	var pitcher_reset_time := batter_reset_time + 0.2
	hit_fairy.reset()
	batter_circle.reset(center_pos, batter_reset_time)
	pitcher_cursor.reset(pitcher_reset_time)
	strike_zone.reset()