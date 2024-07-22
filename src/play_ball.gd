extends Node2D

## TODO:
# 1 - change the background to be less confusing
# 2 - make the sequence of play
# 3 - track swing timing
# 4 - pitches with different X and Y drifts

# UNFORTUNATELY - i think i'm gonna need to add at least a baseball
#                 because the UI alone is NOT clear to anyone who hasn't
#                 played the original game

# refactor?
#  - make pitcher cursor animate with _process instead of tween so they're in sync
#     -> but then you lose the nice easing... unless you want to do it manually :/

# post MVP
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