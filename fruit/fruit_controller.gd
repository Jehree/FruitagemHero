extends Node
class_name FruitController


signal level_completed

@export var fruit_scene: PackedScene
@export var arrow_controller: ArrowController
@export var fruit_name_label: Label
@export var fruit_parent_node: Node

var all_fruit: Array[Fruit]


func _ready() -> void:
	arrow_controller.slice_success.connect(_on_slice_success)


func spawn_fruit(fruit_stats: Array[FruitStats]) -> void:
	for stats in fruit_stats:
		var fruit: Fruit = fruit_scene.instantiate()
		fruit.stats = stats
		fruit_parent_node.add_child(fruit)
		all_fruit.append(fruit)


func clear_fruit() -> void:
	for f in fruit_parent_node.get_children():
		if f is not Fruit: continue
		f.queue_free()
	all_fruit.clear()


func setup_next_fruit_arrows(skip_delay: bool = false) -> void:
	_setup_fruit_arrows(_get_next_active_fruit(), skip_delay)


func _setup_fruit_arrows(fruit: Fruit, skip_delay: bool = false) -> void:
	if not skip_delay:
		await get_tree().create_timer(Settings.settings.fruit_transition_delay).timeout
	arrow_controller.clear_arrows()
	arrow_controller.spawn_arrows(fruit.stats.arrow_sequence)
	fruit_name_label.text = fruit.stats.fruit_name


func _on_slice_success() -> void:
	var current_fruit = _get_next_active_fruit()
	current_fruit.set_active(false)
	
	var next_fruit = _get_next_active_fruit()
	if next_fruit == null:
		level_completed.emit()
		return
	
	_setup_fruit_arrows(next_fruit)


func _get_next_active_fruit() -> Fruit:
	for f in all_fruit:
		if not f.is_active: continue
		return f
	return null
