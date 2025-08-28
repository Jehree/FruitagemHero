extends Label

@export var score_tracker: ScoreTracker


func _ready() -> void:
	score_tracker.score_updated.connect(func(score: int) -> void: text = str(score))
