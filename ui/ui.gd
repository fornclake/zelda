extends CanvasLayer

@export_node_path("Entity") var target

@onready var inventory = $Inventory

var items = {}:
	get: return target.items

func _ready():
	target = get_node(target)
	
	inventory.connect("inventory_changed", $HUD.queue_redraw)
	#inventory.connect("inventory_changed", func(): print(items))


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if inventory.visible:
			_close_inventory()
		else:
			_open_inventory()


func _open_inventory():
	get_tree().paused = true
	await ScreenFX.fade_white_in()
	inventory.show()
	ScreenFX.fade_white_out()


func _close_inventory():
	await ScreenFX.fade_white_in()
	inventory.hide()
	await ScreenFX.fade_white_out()
	get_tree().paused = false
