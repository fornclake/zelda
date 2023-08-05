extends EditorInspectorPlugin


class ExitProperty extends EditorProperty:
	var property_control = preload("res://addons/map_editor/exit_list.tscn").instantiate()
	
	func _init():
		add_child(property_control)
		


func _can_handle(object): return true if object is Map else false


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if name == "exits":
		add_custom_control(ExitProperty.new())
		return true
	return false
