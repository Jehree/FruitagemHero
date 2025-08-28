extends Node
class_name GameController

signal game_started
signal level_advanced

@export var game_screen: Control
@export var start_screen: StartScreen
@export var fruit_collections: Array[FruitCollection]
@export var fruit_controller: FruitController
@export var level_timer: LevelTimer
var level_time: float

var is_transitioning: bool = false

func _ready() -> void:
	start_screen.start_game_requested.connect(_on_start_game_requested)
	fruit_controller.level_completed.connect(_on_level_completed)
	level_timer.game_timer.timeout.connect(_on_level_timer_timeout)
	_switch_to_start_screen()


func _on_level_completed() -> void:
	is_transitioning = true
	
	level_timer.game_timer.paused = true
	await get_tree().create_timer(Settings.settings.level_transition_delay).timeout
	_new_level()
	
	is_transitioning = false


func _on_level_timer_timeout() -> void:
	if is_transitioning: return
	
	_switch_to_start_screen()
	start_screen.set_text("Epic fail...")


func _on_start_game_requested() -> void:
	_start_game()


func _switch_to_start_screen() -> void:
	game_screen.process_mode = Node.PROCESS_MODE_DISABLED
	game_screen.hide()
	start_screen.process_mode = Node.PROCESS_MODE_INHERIT
	start_screen.show()


func _start_game() -> void:
	start_screen.process_mode = Node.PROCESS_MODE_DISABLED
	start_screen.hide()
	game_screen.process_mode = Node.PROCESS_MODE_INHERIT
	game_screen.show()
	
	_new_level(true)
	game_started.emit()


func _new_level(is_first_level: bool = false) -> void:
	if is_first_level:
		level_time = Settings.settings.starting_time_per_level
	else:
		level_time *= Settings.settings.time_per_level_multiplier
	
	var collection: FruitCollection = FruitCollection.get_random_collection(fruit_collections)
	print(collection.name)
	var random_fruit_stats: Array[FruitStats] = _get_random_fruit_stats_in_collection(collection, Settings.settings.num_of_fruit_per_level)
	fruit_controller.clear_fruit()
	fruit_controller.spawn_fruit(random_fruit_stats)
	fruit_controller.setup_next_fruit_arrows(true)
	
	if not is_first_level:
		level_advanced.emit()
	
	level_timer.start_game_timer(level_time)


func _get_random_fruit_stats_in_collection(collection: FruitCollection, count: int) -> Array[FruitStats]:
	var fruit_in_collection: Array[FruitStats] = collection.fruit
	var random_fruit: Array[FruitStats] = []
	
	for i in range(count):
		var rand: int = randi_range(0, fruit_in_collection.size() - 1)
		random_fruit.append(fruit_in_collection[rand])
	
	return random_fruit
