extends Node2D

const ROWS = 4
const COLUMNS = 4
const ITEM_SIZE = Vector2(32, 24)

var items = []
var selected_item = 0 : set = _set_selected_item
var size = ROWS * COLUMNS

@onready var selector = $Selector


func _ready():
	for i in size:
		items.append("")
	print(items)


func _process(delta):
	if Input.is_action_just_pressed("left"):
		selected_item -= 1
	elif Input.is_action_just_pressed("right"):
		selected_item += 1
	elif Input.is_action_just_pressed("up"):
		selected_item -= ROWS
	elif Input.is_action_just_pressed("down"):
		selected_item += ROWS


func _set_selected_item(value):
	selected_item = wrapi(value, 0, size)
	selector.position.x = 32 + selected_item % ROWS * ITEM_SIZE.x
	selector.position.y = 32 + floor(selected_item / COLUMNS) * ITEM_SIZE.y
