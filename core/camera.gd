class_name GridCamera extends Camera2D

const DEFAULT_LIMIT_RECT = Rect2(-10000000, -10000000, 10000000, 10000000)
const CELL_SIZE = Vector2(256, 176)
const VIEWPORT_SIZE = Vector2(160, 144)
const HUD_OFFSET = 0 # 16 when hud is visible
const SCROLL_DURATION = 0.5

@export var target : Node2D

var grid_position:
	get: return world_to_grid(position)
var limit_rect = DEFAULT_LIMIT_RECT: set = _set_limit_rect

@onready var last_grid_position = world_to_grid(target.position)

signal scroll_started
signal scroll_completed


# Initialize the camera and set its initial limit_rect
func _ready() -> void:
	var origin = last_grid_position * CELL_SIZE
	limit_rect = Rect2(origin, origin + CELL_SIZE)
	
	await get_tree().physics_frame # takes 2 frames for tilemap entities to initialize
	await get_tree().physics_frame # TODO make a signal for tilemap ready to await here
	
	if target.has_method("_on_scroll_completed"):
		scroll_completed.connect(target._on_scroll_completed)
	
	emit_signal("scroll_completed")


# Update the camera's position and scroll if necessary
func _physics_process(_delta) -> void:
	var target_grid_position = world_to_grid(target.position)
	position = target.position
	
	if target_grid_position != last_grid_position:
		scroll_screen()
		last_grid_position = target_grid_position


# Scroll the camera smoothly to the new position
func scroll_screen() -> void:
	emit_signal("scroll_started")
	set_physics_process(false)
	
	var target_origin = world_to_grid(target.position) * CELL_SIZE
	var scroll_from = get_screen_center_position()
	
	limit_rect = DEFAULT_LIMIT_RECT
	
	var scroll_to = target.position
	var scroll_to_min = target_origin + VIEWPORT_SIZE / 2
	var scroll_to_max = target_origin + CELL_SIZE - VIEWPORT_SIZE / 2
	
	position = scroll_from
	scroll_to.x = clamp(scroll_to.x, scroll_to_min.x, scroll_to_max.x)
	scroll_to.y = clamp(scroll_to.y, scroll_to_min.y - HUD_OFFSET, scroll_to_max.y)
	
	var tween = create_tween()
	tween.tween_property(self, "position", scroll_to, SCROLL_DURATION)
	await tween.finished
	
	limit_rect = Rect2(target_origin, target_origin + CELL_SIZE)
	
	emit_signal("scroll_completed")
	set_physics_process(true)


func _set_limit_rect(rect : Rect2) -> Rect2:
	limit_rect = rect
	
	limit_left = limit_rect.position.x
	limit_right = limit_rect.size.x
	limit_top = limit_rect.position.y - HUD_OFFSET
	limit_bottom = limit_rect.size.y
	
	return limit_rect


func world_to_grid(pos : Vector2) -> Vector2:
	return Vector2(floor(pos.x/CELL_SIZE.x), floor(pos.y/CELL_SIZE.y))
