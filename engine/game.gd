extends Node2D

@onready var camera : GridCamera = $Camera


func _ready():
	camera.connect("scroll_started", _on_camera_scroll_started)
	camera.connect("scroll_completed", _on_camera_scroll_completed)


func _on_camera_scroll_started():
	for entity in get_tree().get_nodes_in_group("entity"):
		entity.set_physics_process(false)


func _on_camera_scroll_completed():
	for entity in get_tree().get_nodes_in_group("entity"):
		if camera.world_to_grid(entity.position) == camera.grid_position:
			entity.set_physics_process(true)
