@tool
extends Node
class_name AllFruitStatsContainer


@export_tool_button("Get All FruitStat Resources") var action: Callable = _get_all_fruit_stats

@export var _stats: Array[FruitStats] = []
static var stats: Array[FruitStats]


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	stats = _stats


func _get_all_fruit_stats() -> void:
	_stats.clear()
	
	for file_path in DirAccess.get_files_at("res://fruit/fruit_types/"):
		var fruit: FruitStats = load("res://fruit/fruit_types/" + file_path) as FruitStats
		_stats.append(fruit)
