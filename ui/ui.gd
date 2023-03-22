extends CanvasLayer

@export_node_path("Entity") var target

@onready var inv = $Inventory
@onready var hearts = $Hearts


func _ready():
	target = get_node(target)
	hearts.initialize(target)


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if inv.visible:
			_close_inventory()
		else:
			_open_inventory()


func _open_inventory():
	get_tree().paused = true
	await ScreenFX.fade_white_in()
	inv.show()
	ScreenFX.fade_white_out()


func _close_inventory():
	await ScreenFX.fade_white_in()
	inv.hide()
	await ScreenFX.fade_white_out()
	get_tree().paused = false
