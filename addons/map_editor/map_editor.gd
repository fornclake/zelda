@tool
extends EditorPlugin

var exit_property


func _enter_tree():
	exit_property = preload("res://addons/map_editor/exit_plugin.gd").new()
	add_inspector_plugin(exit_property)


func _exit_tree():
	remove_inspector_plugin(exit_property)


func _handles(object):
	if object is Map:
		return true
	return false
