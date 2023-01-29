extends Camera2D

@export var target : Node2D
var last_grid_position := Vector2(0,0)

const CELL_SIZE = Vector2(256, 176)
const VIEWPORT_SIZE = Vector2(160, 144)
const SCROLL_DURATION = 0.5

func _ready():
	last_grid_position = _get_target_grid_position()
	var target_origin = last_grid_position * CELL_SIZE
	limit_left = target_origin.x
	limit_right = target_origin.x + CELL_SIZE.x
	limit_top = target_origin.y
	limit_bottom = target_origin.y + CELL_SIZE.y

func _physics_process(delta):
	var target_grid_position = _get_target_grid_position()
	
	position = target.position
	
	if target_grid_position != last_grid_position:
		scroll_screen()
	
	last_grid_position = target_grid_position

func scroll_screen():
	var scroll_from = get_screen_center_position()
	var target_origin = _get_target_grid_position() * CELL_SIZE
	set_physics_process(false)
	target.set_physics_process(false)
	
	limit_left = -10000000
	limit_right = 10000000
	limit_top = -10000000
	limit_bottom = 10000000
	position = scroll_from
	
	var scroll_to = target.position
	var scroll_to_min = target_origin + VIEWPORT_SIZE / 2
	var scroll_to_max = target_origin + CELL_SIZE - VIEWPORT_SIZE / 2
	scroll_to.x = clamp(scroll_to.x, scroll_to_min.x, scroll_to_max.x)
	scroll_to.y = clamp(scroll_to.y, scroll_to_min.y, scroll_to_max.y)
	
	var tween = create_tween()
	tween.tween_property(self, "position", scroll_to, SCROLL_DURATION)
	await tween.finished
	
	limit_left = target_origin.x
	limit_right = target_origin.x + CELL_SIZE.x
	limit_top = target_origin.y
	limit_bottom = target_origin.y + CELL_SIZE.y
	
	set_physics_process(true)
	target.set_physics_process(true)

func _get_target_grid_position():
	return _get_grid_position(target.position.x, target.position.y)

func _get_grid_position(x,y):
	return Vector2(floor(x/CELL_SIZE.x), floor(y/CELL_SIZE.y))
