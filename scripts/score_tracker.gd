extends Node
class_name ScoreTracker

signal score_updated(score: float)

@export var level_timer: LevelTimer
@export var game_controller: GameController
@export var arrow_controller: ArrowController


var score: int = 0:
	set(value):
		score = round(value)
		score_updated.emit(score)

var error_this_level: bool = false


func _ready() -> void:
	game_controller.game_started.connect(_on_game_start)
	game_controller.level_advanced.connect(_on_level_advanced)
	arrow_controller.slice_error.connect(_on_slice_error)


func _on_game_start() -> void:
	score = 0
	error_this_level = false


func _on_level_advanced() -> void:
	score += 100
	score += int(level_timer.value)
	
	if not error_this_level:
		score += 50
	
	error_this_level = false


func _on_slice_error() -> void:
	error_this_level = true


func round_to_decimal_place(num: float, decimal_place: float) -> float:
	return round(num * pow(10.0, decimal_place)) / pow(10.0, decimal_place)
