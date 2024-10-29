class_name GameScene extends SubViewport

var map : Map
var player : Actor
var camera : GridCamera

func _init(map_path : String, p_player : Actor):
	map = load(map_path).instantiate()
	camera = GridCamera.new()
	player = p_player
	canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	camera.scroll_started.connect(_on_camera_scroll_started)
	camera.scroll_completed.connect(_on_camera_scroll_completed)


func _enter_tree():
	add_child(map)
	add_child(camera)
	camera.target = player
	map.add_child(player)
	player.position = Vector2(119,82) * 16 # TEMP OVERWORLD DEFAULT STARTING LOCATION


func _on_camera_scroll_started() -> void:
	for actor in get_tree().get_nodes_in_group("actor"):
		actor.set_physics_process(false)
		actor.sprite.stop()


func _on_camera_scroll_completed() -> void:
	for actor in get_tree().get_nodes_in_group("actor"):
		if camera.world_to_grid(actor.position) == camera.grid_position:
			actor.set_physics_process(true)
