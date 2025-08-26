extends TextureRect
class_name Fruit


@export var stats: FruitStats
var is_active: bool = true

func _ready() -> void:
	if stats == null: return
	
	texture = stats.texture


func set_active(active: bool) -> void:
	is_active = active
	
	if active:
		modulate = Color.WHITE
	else:
		modulate = Color.BLACK
