extends Node
class_name Settings


@export var _settings: SettingsResource
static var settings: SettingsResource = null

func _enter_tree() -> void:
	if settings == null:
		settings = _settings
