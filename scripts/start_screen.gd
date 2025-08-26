extends Control
class_name StartScreen

signal start_game_requested

@export var menu_label: Label
@export var press_any_key_timer: Timer
@export var press_any_key_label: Label
@export var score_label: Label
@export var score_tracker: ScoreTracker


func _ready() -> void:
	press_any_key_timer.wait_time = Settings.settings.press_any_key_delay
	press_any_key_timer.timeout.connect(_on_press_any_key_timeout)
	visibility_changed.connect(_on_visibility_changed)
	score_tracker.score_updated.connect(func(score: int): score_label.text = str(score))
	_on_visibility_changed()


func _input(event: InputEvent) -> void:
	if not press_any_key_label.visible: return
	
	if event is InputEventKey and event.is_pressed():
		start_game_requested.emit()
		get_viewport().set_input_as_handled()


func _on_visibility_changed() -> void:
	if not visible: return
	press_any_key_label.hide()
	press_any_key_timer.start()


func _on_press_any_key_timeout() -> void:
	press_any_key_label.show()


func set_text(text: String) -> void:
	menu_label.text = text
