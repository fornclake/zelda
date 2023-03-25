extends Node2D

const ROWS = 4
const COLUMNS = 4
const TOP_LEFT = Vector2(16, 8) # where to start drawing items
const ITEM_SIZE = Vector2(32, 24) # distance between items
const SELECTOR_OFFSET = Vector2(-2, 1)

const BG_TEXTURE = preload("res://ui/inventory.png")
const SELECTOR_TEXTURE = preload("res://ui/selector.png")

var items = {}:
	get: return get_parent().items

var selected_item = 0:
	set(value):
		selected_item = wrapi(value, 0, ROWS * COLUMNS)
		queue_redraw()

signal inventory_changed


func _process(delta):
	if Input.is_action_just_pressed("left"):
		selected_item -= 1
	elif Input.is_action_just_pressed("right"):
		selected_item += 1
	elif Input.is_action_just_pressed("up"):
		selected_item -= ROWS
	elif Input.is_action_just_pressed("down"):
		selected_item += ROWS
	
	if Input.is_action_just_pressed("b"):
		_swap_item("B", selected_item)
	if Input.is_action_just_pressed("a"):
		_swap_item("A", selected_item)


func _draw():
	draw_texture(BG_TEXTURE, Vector2.ZERO) # draw background
	
	# draw inventory items
	for i in items:
		if not items.get(i) or typeof(i) == TYPE_STRING: continue
		var x = TOP_LEFT.x + i % ROWS * ITEM_SIZE.x
		var y = TOP_LEFT.y + floor(i / COLUMNS) * ITEM_SIZE.y
		draw_texture(items[i].icon, Vector2(x,y))
	
	# draw selection cursor
	var wrapped = Vector2(selected_item % ROWS, floor(selected_item / COLUMNS))
	var selector_position = TOP_LEFT + wrapped * ITEM_SIZE + SELECTOR_OFFSET
	draw_texture(SELECTOR_TEXTURE, selector_position)


func _swap_item(hud,inv):
	var swap = items.get(hud)
	items[hud] = items.get(inv)
	items[inv] = swap
	
	if items[inv] == null:
		items.erase(inv)
	
	emit_signal("inventory_changed")
	queue_redraw()
