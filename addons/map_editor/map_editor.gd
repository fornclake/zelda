@tool
extends EditorPlugin

var inspector_plugin


func _enter_tree():
	inspector_plugin = preload("res://addons/map_editor/map_inspector.gd").new(get_editor_interface())
	add_inspector_plugin(inspector_plugin)


func _exit_tree():
	remove_inspector_plugin(inspector_plugin)


func _handles(object):
	if object is Map:
		return true
	return false
