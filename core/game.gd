extends Node2D

@onready var camera : GridCamera = $Camera


func _ready() -> void:
	camera.scroll_started.connect(_on_camera_scroll_started)
	camera.scroll_completed.connect(_on_camera_scroll_completed)


func _on_camera_scroll_started() -> void:
	for actor in get_tree().get_nodes_in_group("actor"):
		actor.set_physics_process(false)
		actor.sprite.stop()


func _on_camera_scroll_completed() -> void:
	for actor in get_tree().get_nodes_in_group("actor"):
		if camera.world_to_grid(actor.position) == camera.grid_position:
			actor.set_physics_process(true)
