extends EditorProperty

const FILE_DIALOG_RECT = Rect2i(Vector2i(320, 192), Vector2i(1280, 720))

var _exits : Dictionary
var _selected_exit : Exit
var _indices := {} # option : exit

# Inspector controls
var _options_button := OptionButton.new()
var _editor_panel := PanelContainer.new()
var _label_edit := LineEdit.new()
var _path_button := Button.new()
var _next_dropdown := OptionButton.new()

signal reload_exits # connects to map.gd

const Exit = preload("res://core/map.gd").Exit

##################
## Initializing ##
# Requires map object's exits dictionary
func _init(p_exits : Dictionary):
	_exits = p_exits
	_options_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_options_button.pressed.connect(_initialize_options)
	_reset_options_text()
	add_child(_options_button)


func _initialize_options() -> void:
	_options_button.item_selected.connect(_initialize_properties.unbind(1))
	_options_button.item_selected.connect(_option_selected)
	_options_button.pressed.disconnect(_initialize_options)
	_reload_options()
	_reset_options_text()


# Initialize properties
func _initialize_properties() -> void:
	var property_list := VBoxContainer.new()
	property_list.add_child(_create_property("label", _label_edit))
	property_list.add_child(_create_property("map_path", _path_button))
	property_list.add_child(_create_property("next_exit", _next_dropdown))
	
	_options_button.item_selected.disconnect(_initialize_properties)
	_label_edit.text_changed.connect(_set_label)
	_path_button.pressed.connect(_request_map_path)
	_path_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_path_button.clip_text = true
	_next_dropdown.disabled = true
	
	# Add editor panel
	_editor_panel.add_child(property_list)
	set_bottom_editor(_editor_panel)
	add_child(_editor_panel)


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
	var linked := []
	var available := []
	_indices = {}
	_options_button.clear()
	
	# Add custom controls
	_options_button.get_popup().add_icon_item(preload("res://editor/svg/ReloadSmall.svg"), "Reload")
	
	# Validity check
	for exit in _exits.values():
		var array = linked if _is_linked(exit) else available
		array.append(exit)
	
	# Add valid exits
	_options_button.add_separator("Linked")
	for exit in linked:
		_options_button.add_item(_format_label(exit))
		_indices[_options_button.item_count-1] = exit.cell
	
	# Add invalid exits
	_options_button.add_separator("Available")
	for exit in available:
		_options_button.add_item(_format_label(exit))
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
			_selected_exit = _exits[_indices[index]]
			_editor_panel.show()
			_load_exit(_selected_exit)


# Set option button text to exit cell and load exit properties into controls
func _load_exit(exit : Exit) -> void:
	_options_button.text = str(exit.cell)
	_label_edit.text = exit.label
	if exit.path != "":
		_set_map_path(exit.path)
		if not exit.next:
			pass


#############
## Editing ##
# Update exit dictionary to text input and marks scene as unsaved
func _set_label(new_label : String) -> void:
	_selected_exit.label = new_label
	_reload_options()
	emit_changed("exits", _exits)
	_options_button.text = str(_selected_exit.cell)


func _request_map_path() -> void:
	var dialog = FileDialog.new()
	var directory = DirAccess.open("res://")
	dialog.add_filter("*.tscn", "Maps")
	dialog.current_dir = "res://data/maps/" if directory.dir_exists("res://data/maps/") \
			else "res://data/" if directory.dir_exists("res://data/") \
			else "res://"
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.file_selected.connect(_set_map_path)
	add_child(dialog)
	dialog.popup(FILE_DIALOG_RECT)


func _set_map_path(path : String) -> void:
	_path_button.text = path
	_next_dropdown.clear()
	
	var map = load(path).instantiate()
	for exit in map.exits.values():
		if _is_linked(exit):
			_next_dropdown.add_item(_format_label(exit))
	map.free()
	
	if _next_dropdown.item_count > 0:
		_next_dropdown.disabled = false
		_next_dropdown.alignment = HORIZONTAL_ALIGNMENT_CENTER



func _format_label(exit : Exit) -> String:
	return str(exit.label) + " " + str(exit.cell)


func _is_linked(exit : Exit) -> bool:
	return true if exit.label != "" else false
