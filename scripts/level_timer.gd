extends ProgressBar
class_name LevelTimer

@export var timer: Timer


func _process(_delta: float) -> void:
	value = (timer.time_left / timer.wait_time) * 100
