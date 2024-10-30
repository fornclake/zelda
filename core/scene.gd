class_name GameScene extends SubViewport

var map: Map
var player: Actor
var camera: GridCamera
var entrance: String

func _init(map_path: String, p_entrance: String, p_player: Actor):
	map = load(map_path).instantiate()
	camera = GridCamera.new()
	player = p_player
	entrance = p_entrance
	canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	camera.scroll_started.connect(_on_camera_scroll_started)
	camera.scroll_completed.connect(_on_camera_scroll_completed)


func _enter_tree():
	add_child(map)
	add_child(camera)
	camera.target = player
	map.add_child(player)
	player.position = map.map_to_local(_find_exit(entrance))


func _find_exit(exit_name: String) -> Vector2i:
	for exit in map.exits.values():
		if exit.name == exit_name:
			return exit.cell
	return Vector2i.ZERO

func _on_camera_scroll_started() -> void:
	for actor in get_tree().get_nodes_in_group("actor"):
		actor.set_physics_process(false)
		actor.sprite.stop()


func _on_camera_scroll_completed() -> void:
	for actor in get_tree().get_nodes_in_group("actor"):
		if camera.world_to_grid(actor.position) == camera.grid_position:
			actor.set_physics_process(true)
