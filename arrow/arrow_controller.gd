extends Node
class_name ArrowController

signal slice_success
signal slice_error

@export var arrow_parent_node: Node
@export var arrow_scene: PackedScene
var arrows: Array[Arrow]


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"up"):
		_handle_arrow_input(Arrow.ArrowType.UP)
		return
	
	if Input.is_action_just_pressed(&"down"):
		_handle_arrow_input(Arrow.ArrowType.DOWN)
		return
	
	if Input.is_action_just_pressed(&"left"):
		_handle_arrow_input(Arrow.ArrowType.LEFT)
		return
	
	if Input.is_action_just_pressed(&"right"):
		_handle_arrow_input(Arrow.ArrowType.RIGHT)
		return


func _handle_arrow_input(input: Arrow.ArrowType) -> void:
	if arrows.is_empty(): return
	var next_arrow: Arrow = _get_next_active_arrow()
	
	if next_arrow == null:
		# level is already finished, we're just waiting for the level transition delay
		return
	
	if input != next_arrow.type: 
		slice_error.emit()
		reactivate_all_arrows()
		return
	
	next_arrow.set_active(false)
	
	if _get_next_active_arrow() == null:
		slice_success.emit()


func _get_next_active_arrow() -> Arrow:
	for a in arrows:
		if not a.is_active: continue
		return a
	return null


func clear_arrows() -> void:
	for child in arrow_parent_node.get_children():
		if child is not Arrow: continue
		child.queue_free()
	
	arrows.clear()


func spawn_arrows(arrows_to_spawn: Array[Arrow.ArrowType]) -> void:
	for type in arrows_to_spawn:
		var arrow: Arrow = arrow_scene.instantiate()
		arrow.type = type
		arrow_parent_node.add_child(arrow)
		arrows.append(arrow)


func reactivate_all_arrows() -> void:
	for a in arrows:
		a.set_active(true)
