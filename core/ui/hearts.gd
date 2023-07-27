extends Node2D

const HEART_TEXTURE = preload("res://core/ui/hearts.png")
const HEART_SIZE = Vector2(8,8)
const ROW_COUNT = 7

var hearts := 3
var health := 3

func _draw():
	for heart in int(hearts):
		var offset_x = (heart % ROW_COUNT) * HEART_SIZE.x
		@warning_ignore("integer_division")
		var offset_y = floor(heart / ROW_COUNT) * HEART_SIZE.y
		var fraction = (health - floor(health)) * 4
		var src_rect = Rect2(fraction * 8,0,8,8)
		
		if heart < floor(health):
			src_rect = Rect2(32,0,8,8)
		elif heart > floor(health):
			src_rect = Rect2(0,0,8,8)
		
		draw_texture_rect_region(HEART_TEXTURE, Rect2(Vector2(offset_x, offset_y), HEART_SIZE), src_rect)
