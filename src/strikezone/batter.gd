class_name Batter
extends Node2D

var top: float:
	get: return chest.position.y
var bot: float:
	get: return knee.position.y
var dist: float:
	get: return bot - top

@onready var chest: Sprite2D = %Chest
@onready var knee: Sprite2D = %Knee
