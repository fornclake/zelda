extends Camera2D

@export var target : Node2D

const screen_size = Vector2i(256, 176)

func _physics_process(delta):
	var origin = _get_grid_position(target.position.x, target.position.y) * screen_size
	limit_left = origin.x
	limit_right = origin.x + screen_size.x
	limit_top = origin.y
	limit_bottom = origin.y + screen_size.y
	
	position = target.position

func _get_grid_position(x,y):
	return Vector2i(floor(x/screen_size.x), floor(y/screen_size.y))
