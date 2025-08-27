extends ProgressBar
class_name LevelTimer

@export var game_timer: Timer
@export var bar_tick_timer: Timer


func _ready() -> void:
	bar_tick_timer.wait_time = Settings.settings.timer_bar_tick_delay
	bar_tick_timer.timeout.connect(_on_bar_tick_timer_timeout)


func _on_bar_tick_timer_timeout() -> void:
	value = (game_timer.time_left / game_timer.wait_time) * 100


func start_game_timer() -> void:
	value = 100
	game_timer.paused = false
	game_timer.start()
	bar_tick_timer.start()
