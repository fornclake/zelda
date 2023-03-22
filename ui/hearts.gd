extends Node2D

@export_range(1,14) var heart_count : int = 3 : set = _set_heart_count
@export_range(0,14,0.25) var health : float = 3.0 : set = _set_health

const HEART_TEXTURE = preload("res://ui/hearts.png")
const HEART_SIZE = Vector2(8,8)
const ROW_COUNT = 7

var target

func initialize(t):
	target = t
	_update_hearts()
	target.connect("on_hit", _update_hearts)

func _update_hearts():
	heart_count = target.hearts
	health = target.health

func _set_heart_count(value):
	heart_count = value
	health = value

func _set_health(value):
	health = value
	queue_redraw()

func _draw():
	for heart in heart_count:
		var offset_x = (heart % ROW_COUNT) * HEART_SIZE.x
		var offset_y = floor(heart / ROW_COUNT) * HEART_SIZE.y
		var fraction = (health - floor(health)) * 4
		var src_rect = Rect2(fraction * 8,0,8,8)
		
		if heart < floor(health):
			src_rect = Rect2(32,0,8,8)
		elif heart > floor(health):
			src_rect = Rect2(0,0,8,8)
		
		draw_texture_rect_region(HEART_TEXTURE, Rect2(Vector2(offset_x, offset_y), HEART_SIZE), src_rect)
