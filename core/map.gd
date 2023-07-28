@icon("res://editor/svg/Map.svg")
class_name Map extends TileMap

func on_step(actor : Actor) -> String:
	var data = get_cell_tile_data(1, local_to_map(actor.position))
	if data:
		return data.get_custom_data("on_step")
	return ""


func slash(cell : Vector2i) -> void:
	var data = get_cell_tile_data(0, cell)
	if data and data.get_custom_data("is_cuttable"):
		var cut_fx = preload("res://core/vfx/grass_cut.tscn").instantiate()
		cut_fx.position = map_to_local(cell)
		add_child(cut_fx)
		erase_cell(0, cell)
