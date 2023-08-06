extends EditorInspectorPlugin


var _editor_interface : EditorInterface

var current_map : Map

class ExitEditor extends EditorProperty:
	const OPTION_COMMAND_COUNT = 1
	
	var option : OptionButton
	var popup : PopupMenu
	var exits : Dictionary
	
	var editor_panel : PanelContainer
	
	func _init(p_exits : Dictionary):
		exits = p_exits
		
		option = OptionButton.new()
		reset_text()
		add_child(option)
		
		popup = option.get_popup()
		
		popup.add_icon_item(preload("res://editor/svg/ReloadSmall.svg"), " Reload")
		popup.add_separator()
		
		for exit in exits:
			popup.add_item(str(exit))
		
		popup.index_pressed.connect(edit_exits)
		
		editor_panel = PanelContainer.new()
		editor_panel.hide()
		set_bottom_editor(editor_panel)
		add_child(editor_panel)
	
	
	func reset_text():
		option.text = "Exit List (size " + str(exits.size()) + ")"
	
	
	func edit_exits(exit_index):
		if exit_index <= OPTION_COMMAND_COUNT:
			option.selected = -1
			editor_panel.hide()
			reset_text()
			#option.show_popup()
		else:
			editor_panel.show()
			option.text = str(exits.keys()[exit_index - OPTION_COMMAND_COUNT - 1])


func _init(editor_interface):
	_editor_interface = editor_interface


func _can_handle(object): return true if object is Map else false


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if object is Map:
		current_map = object
	
	if name == "exits":
		var exit_editor = ExitEditor.new(object.exits)
		add_property_editor("", exit_editor)
		return true
	
	return false