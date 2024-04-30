extends EditorInspectorPlugin

const ExitEditor = preload("res://addons/map_editor/exit_editor.gd")

func _can_handle(object):
	return true if object is Map else false

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if name == "exits":
		var exit_editor = ExitEditor.new(object)
		add_property_editor("", exit_editor)
		return true
	
	return false
