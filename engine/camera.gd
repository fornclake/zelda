extends Camera2D

@export var target : Node2D
@onready var last_grid_position = _get_target_grid_position()

const CELL_SIZE = Vector2(256, 176)
const VIEWPORT_SIZE = Vector2(160, 144)
const SCROLL_DURATION = 0.5

func _ready():
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
	
	_set_limits()
	
	var scroll_to = target.position
	var scroll_to_min = target_origin + VIEWPORT_SIZE / 2
	var scroll_to_max = target_origin + CELL_SIZE - VIEWPORT_SIZE / 2
	scroll_to.x = clamp(scroll_to.x, scroll_to_min.x, scroll_to_max.x)
	scroll_to.y = clamp(scroll_to.y, scroll_to_min.y, scroll_to_max.y)
	
	position = scroll_from
	
	var tween = create_tween()
	tween.tween_property(self, "position", scroll_to, SCROLL_DURATION)
	await tween.finished
	
	_set_limits(target_origin.x, target_origin.x + CELL_SIZE.x,
			target_origin.y, target_origin.y + CELL_SIZE.y)
	
	set_physics_process(true)
	target.set_physics_process(true)

func _set_limits(l=-10000000, r=10000000, t=-10000000, b=10000000):
	limit_left = l
	limit_right = r
	limit_top = t
	limit_bottom = b

func _get_target_grid_position():
	return _get_grid_position(target.position.x, target.position.y)

func _get_grid_position(x,y):
	return Vector2(floor(x/CELL_SIZE.x), floor(y/CELL_SIZE.y))
