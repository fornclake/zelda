extends Node2D

const ROWS = 4
const COLUMNS = 4
const TOP_LEFT = Vector2(16, 8) # where to start drawing items
const ITEM_SIZE = Vector2(32, 24) # distance between items
const SELECTOR_OFFSET = Vector2(-2, 1)

const BG_TEXTURE = preload("res://core/ui/inventory.png")
const SELECTOR_TEXTURE = preload("res://core/ui/selector.png")

var items := {}

var selected_item = 0:
	set(value):
		selected_item = wrapi(value, 0, ROWS * COLUMNS)
		Sound.play(preload("res://data/sfx/LA_Menu_Cursor.wav"))
		queue_redraw()

var input_direction:
	get: return Vector2(
		int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left")),
		int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	)

signal inventory_changed(items)


func _process(_delta):
	if not ScreenFX.playing:
		_handle_input_actions()


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


func _handle_input_actions():
	if input_direction != Vector2.ZERO:
		_update_selected_item(input_direction)
	elif Input.is_action_just_pressed("b"):
		_swap_item("B", selected_item)
	elif Input.is_action_just_pressed("a"):
		_swap_item("A", selected_item)


func _update_selected_item(input_dir):
	var item_change = input_dir.x + ROWS * input_dir.y
	selected_item += item_change


func _swap_item(hud,inv):
	var swap = items.get(hud)
	items[hud] = items.get(inv)
	items[inv] = swap
	Sound.play(preload("res://data/sfx/LA_Menu_Select.wav"))
	
	if items[inv] == null:
		items.erase(inv)
	
	emit_signal("inventory_changed", items)
	queue_redraw()
