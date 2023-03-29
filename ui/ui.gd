extends CanvasLayer

@export_node_path("Entity") var target

@onready var inventory = $Inventory

var items = {}:
	get: return target.items

var hearts:
	get: return target.hearts

var health:
	get: return target.health


func _ready():
	target = get_node(target)
	
	inventory.connect("inventory_changed", $HUD.queue_redraw)
	target.connect("on_hit", $Hearts.queue_redraw)


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if inventory.visible:
			_close_inventory()
		else:
			_open_inventory()


func _open_inventory():
	get_tree().paused = true
	Sound.play(DEF.SFX.PauseMenu_Open)
	await ScreenFX.fade_white_in()
	inventory.show()
	ScreenFX.fade_white_out()


func _close_inventory():
	Sound.play(DEF.SFX.PauseMenu_Close)
	await ScreenFX.fade_white_in()
	inventory.hide()
	await ScreenFX.fade_white_out()
	get_tree().paused = false
