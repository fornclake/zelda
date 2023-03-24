extends Node2D

const ROWS = 4
const COLUMNS = 4
const TOP_LEFT = Vector2(16, 8) # where to start drawing items
const ITEM_SIZE = Vector2(32, 24) # distance between items
const SELECTOR_OFFSET = Vector2(-2, 1)

const BG_TEXTURE = preload("res://ui/inventory.png")
const SELECTOR_TEXTURE = preload("res://ui/selector.png")

var items = {}
var selected_item : set = _set_selected_item
var size = ROWS * COLUMNS
var selector_position = TOP_LEFT
var target

func initialize(t):
	target = t
	
	var index = 0
	for item in target.items:
		if index > 1: # skip first 2 items from HUD
			items[index - 2] = item
		index += 1
	
	selected_item = 0


func _process(delta):
	if Input.is_action_just_pressed("left"):
		selected_item -= 1
	elif Input.is_action_just_pressed("right"):
		selected_item += 1
	elif Input.is_action_just_pressed("up"):
		selected_item -= ROWS
	elif Input.is_action_just_pressed("down"):
		selected_item += ROWS


func _draw():
	draw_texture(BG_TEXTURE, Vector2.ZERO)
	
	for i in items:
		var x = TOP_LEFT.x + i % ROWS * ITEM_SIZE.x
		var y = TOP_LEFT.y + floor(i / COLUMNS) * ITEM_SIZE.y
		draw_texture(items[i].icon, Vector2(x,y))
	
	draw_texture(SELECTOR_TEXTURE, selector_position)


func _set_selected_item(value):
	selected_item = wrapi(value, 0, size)
	
	var wrapped = Vector2(selected_item % ROWS, floor(selected_item / COLUMNS))
	selector_position = TOP_LEFT + wrapped * ITEM_SIZE + SELECTOR_OFFSET
	queue_redraw()
