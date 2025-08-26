extends TextureRect
class_name Arrow

enum ArrowType {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var active_texture: Texture2D
@export var inactive_texture: Texture2D

var type: ArrowType
var is_active: bool = true

func _ready() -> void:
	active_texture = get_rotated_texture(active_texture)
	inactive_texture = get_rotated_texture(inactive_texture)
	texture = active_texture


func get_rotated_texture(t: Texture2D) -> Texture2D:
	if type == ArrowType.UP: return t
	
	var image = t.get_image()
	
	if type == ArrowType.DOWN:
		image.rotate_180()
	elif type == ArrowType.RIGHT:
		image.rotate_90(CLOCKWISE)
	elif type == ArrowType.LEFT:
		image.rotate_90(COUNTERCLOCKWISE)
	
	return ImageTexture.create_from_image(image)


func set_active(active: bool) -> void:
	if active:
		texture = active_texture
	else:
		texture = inactive_texture
	
	is_active = active
