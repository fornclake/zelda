extends EditorProperty

var _options_button := OptionButton.new()
var _editor_panel := PanelContainer.new()
var _name_edit := LineEdit.new()
var _path_button := Button.new()
var _next_dropdown := OptionButton.new()

var _exits : Dictionary
var _selected_exit : Dictionary
var _indices := {}

signal reload_exits
signal update_exits(exits)


func _init(p_exits : Dictionary):
	_exits = p_exits
	
	var property_list := VBoxContainer.new()
	_editor_panel.add_child(property_list)
	property_list.add_child(_create_property("name", _name_edit))
	property_list.add_child(_create_property("map_path", _path_button))
	property_list.add_child(_create_property("next_exit", _next_dropdown))
	
	_options_button.item_selected.connect(_option_selected)
	_name_edit.text_changed.connect(_set_name)
	_name_edit.text_submitted.connect(_update_selected.unbind(1))
	
	_reload_options()
	_reset_options_text()
	
	set_bottom_editor(_editor_panel)
	_editor_panel.hide()
	
	add_child(_options_button)
	add_child(_editor_panel)


func _reset_options_text() -> void:
	_options_button.text = "Exit List (size " + str(_exits.size()) + ")"
	_options_button.icon = null


func _create_property(p_name : String, p_control) -> HBoxContainer:
	var property := HBoxContainer.new()
	var label := Label.new()
	
	label.text = p_name
	for control in [property, label, p_control]:
		control.anchors_preset = PRESET_FULL_RECT
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	property.add_child(label)
	property.add_child(p_control)
	
	return property


func _option_selected(index : int) -> void:
	match index:
		0: # Reload
			reload_exits.emit()
			_reload_options()
			_reset_options_text()
			_editor_panel.hide()
		_:
			_editor_panel.show()
			_selected_exit = _exits[_indices[index]]
			_load_exit(_selected_exit)
			


func _update_selected() -> void:
	_reload_options()
	_options_button.text = str(_selected_exit.cell)


func _load_exit(exit : Dictionary) -> void:
	_options_button.text = str(exit.cell)
	_name_edit.text = exit.name


func _set_name(new_name : String) -> void:
	_selected_exit.name = new_name
	emit_changed("exits", _exits)


func _reload_options() -> void:
	_indices = {}
	_options_button.clear()
	_options_button.get_popup().add_icon_item(preload("res://editor/svg/ReloadSmall.svg"), "Reload")
	
	var valid := []
	var invalid := []
	for exit in _exits.values():
		var validity = valid if exit.name != "" else invalid
		validity.append(exit)
	
	_options_button.add_separator("Valid")
	for exit in valid:
		_options_button.add_item(str(exit.cell) + " " + exit.name)
		_indices[_options_button.item_count-1] = exit.cell
	
	_options_button.add_separator("Invalid")
	for exit in invalid:
		_options_button.add_item(str(exit.cell) + " " + exit.name)
		_indices[_options_button.item_count-1] = exit.cell
