extends CanvasLayer

@export_node_path("Entity") var target

@onready var hud = $HUD
@onready var hearts = $HUD/Hearts
@onready var inventory = $Inventory

func _ready():
	target = get_node(target)
	_inventory_changed(target.items)
	inventory.connect("inventory_changed", _inventory_changed)
	target.connect("on_hit", _target_on_hit)


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if inventory.visible:
			_close_inventory()
		else:
			_open_inventory()


func _target_on_hit(new_health):
	hearts.health = new_health


func _inventory_changed(new_items):
	inventory.items = new_items # redundant
	target.items = new_items
	hud.items = new_items
	hud.queue_redraw()


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
