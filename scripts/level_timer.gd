extends ProgressBar
class_name LevelTimer

@export var game_timer: Timer
@export var bar_tick_timer: Timer
@export var arrow_controller: ArrowController

var level_time: float

func _ready() -> void:
	arrow_controller.slice_success.connect(_on_slice_success)
	bar_tick_timer.wait_time = Settings.settings.timer_bar_tick_delay
	bar_tick_timer.timeout.connect(_on_bar_tick_timer_timeout)


func _on_bar_tick_timer_timeout() -> void:
	refresh_timer_bar()


func _on_slice_success() -> void:
	_add_time_to_game_timer(Settings.settings.time_back_on_successful_slice)
	refresh_timer_bar()


func _add_time_to_game_timer(add: float) -> void:
	level_time += add
	game_timer.start(game_timer.time_left + add)


func refresh_timer_bar() -> void:
	value = (game_timer.time_left / level_time) * 100
	bar_tick_timer.start()


func start_game_timer(time: float) -> void:
	level_time = time
	game_timer.wait_time = time
	value = 100
	game_timer.paused = false
	game_timer.start()
	bar_tick_timer.start()


func get_percentage_time_left() -> int:
	return int((game_timer.time_left / level_time) * 100)
