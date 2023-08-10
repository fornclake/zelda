extends EditorProperty

var _exits : Dictionary
var _selected_exit : Dictionary
var _indices := {} # option : exit

# Inspector controls
var _options_button := OptionButton.new()
var _editor_panel := PanelContainer.new()
var _name_edit := LineEdit.new()
var _path_button := Button.new()
var _next_dropdown := OptionButton.new()

signal reload_exits # connects to map.gd


##################
## Initializing ##
# Requires map object's exits dictionary
func _init(p_exits : Dictionary):
	_exits = p_exits
	_options_button.text = "Exit List"
	_options_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_options_button.pressed.connect(_initialize_options)
	add_child(_options_button)


func _initialize_options():
	_options_button.pressed.disconnect(_initialize_options)
	
	# Initialize properties
	var property_list := VBoxContainer.new()
	_editor_panel.add_child(property_list)
	property_list.add_child(_create_property("name", _name_edit))
	property_list.add_child(_create_property("map_path", _path_button))
	property_list.add_child(_create_property("next_exit", _next_dropdown))
	
	# Connect property controls
	_options_button.item_selected.connect(_option_selected)
	_name_edit.text_changed.connect(_set_name)
	
	# Initialize options and add editors
	_reload_options()
	_reset_options_text()
	
	add_child(_editor_panel)
	set_bottom_editor(_editor_panel)
	_editor_panel.hide()


# Creates a labeled control that emulates inspector properties
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


###############
## Reloading ##
# Clear option menu, add custom controls, and sort exits by their validity
func _reload_options() -> void:
	var valid := []
	var invalid := []
	_indices = {}
	_options_button.clear()
	
	# Add custom controls
	_options_button.get_popup().add_icon_item(preload("res://editor/svg/ReloadSmall.svg"), "Reload")
	
	# Validity check
	for exit in _exits.values():
		var validity = valid if exit.name != "" else invalid
		validity.append(exit)
	
	# Add valid exits
	_options_button.add_separator("Valid")
	for exit in valid:
		_options_button.add_item(str(exit.cell) + " " + exit.name)
		_indices[_options_button.item_count-1] = exit.cell
	
	# Add invalid exits
	_options_button.add_separator("Invalid")
	for exit in invalid:
		_options_button.add_item(str(exit.cell) + " " + exit.name)
		_indices[_options_button.item_count-1] = exit.cell


# Set button text similar to Dictionary property editor
func _reset_options_text() -> void:
	_options_button.text = "Exit List (size " + str(_exits.size()) + ")"
	_options_button.icon = null


###############
## Selecting ##
# Custom control and exit selection logic
func _option_selected(index : int) -> void:
	match index:
		0: # Reload
			reload_exits.emit()
			_reload_options()
			_reset_options_text()
			_editor_panel.hide()
		_: # Exit selected
			_editor_panel.show()
			_selected_exit = _exits[_indices[index]]
			_load_exit(_selected_exit)


# Set option button text to exit cell and load exit properties into controls
func _load_exit(exit : Dictionary) -> void:
	_options_button.text = str(exit.cell)
	_name_edit.text = exit.name


#############
## Editing ##
# Update exit dictionary to text input and marks scene as unsaved
func _set_name(new_name : String) -> void:
	_selected_exit.name = new_name
	_reload_options()
	emit_changed("exits", _exits)
	_options_button.text = str(_selected_exit.cell)

