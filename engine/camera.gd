extends Camera2D

const DEFAULT_LIMIT_RECT = Rect2(-10000000, -10000000, 10000000, 10000000)
const CELL_SIZE = Vector2(256, 176)
const VIEWPORT_SIZE = Vector2(160, 144)
const SCROLL_DURATION = 0.5

@export var target : Node2D

var limit_rect = DEFAULT_LIMIT_RECT: set = _set_limit_rect

@onready var last_grid_position = _get_target_grid_position()


func _ready():
	var origin = last_grid_position * CELL_SIZE
	limit_rect = Rect2(origin, origin + CELL_SIZE)


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
	
	limit_rect = DEFAULT_LIMIT_RECT
	
	var scroll_to = target.position
	var scroll_to_min = target_origin + VIEWPORT_SIZE / 2
	var scroll_to_max = target_origin + CELL_SIZE - VIEWPORT_SIZE / 2
	scroll_to.x = clamp(scroll_to.x, scroll_to_min.x, scroll_to_max.x)
	scroll_to.y = clamp(scroll_to.y, scroll_to_min.y - 16, scroll_to_max.y)
	
	position = scroll_from
	
	var tween = create_tween()
	tween.tween_property(self, "position", scroll_to, SCROLL_DURATION)
	await tween.finished
	
	limit_rect = Rect2(target_origin, target_origin + CELL_SIZE)
	
	set_physics_process(true)
	target.set_physics_process(true)


func _set_limit_rect(rect):
	limit_rect = rect
	
	limit_left = limit_rect.position.x
	limit_right = limit_rect.size.x
	limit_top = limit_rect.position.y - 16
	limit_bottom = limit_rect.size.y
	
	return limit_rect


func _get_target_grid_position():
	return _get_grid_position(target.position.x, target.position.y)


func _get_grid_position(x,y):
	return Vector2(floor(x/CELL_SIZE.x), floor(y/CELL_SIZE.y))
