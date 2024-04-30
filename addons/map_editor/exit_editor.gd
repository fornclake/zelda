extends EditorProperty

const FILE_DIALOG_RECT = Rect2i(Vector2i(320, 192), Vector2i(1280, 720))

var _map : Map
var selected_exit
var _linked_map
var _indices := {} # option : exit

# Inspector controls
var _exit_dropdown := OptionButton.new()
var _editor_panel := PanelContainer.new()
var _name_edit := LineEdit.new()
var _path_button := Button.new()
var _linked_exit_dropdown := OptionButton.new()

signal reload_exits # connects to map.gd


##################
## Initializing ##
# Requires map object's exits dictionary
func _init(p_map : Map):
	_map = p_map
	reload_exits.connect(_map.reload_exits)
	_exit_dropdown.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_exit_dropdown.pressed.connect(_initialize_options)
	_reset_options_text()
	add_child(_exit_dropdown)


func _initialize_options() -> void:
	_exit_dropdown.item_selected.connect(_initialize_properties.unbind(1))
	_exit_dropdown.item_selected.connect(_option_selected)
	_exit_dropdown.pressed.disconnect(_initialize_options)
	_reload_options()
	_reset_options_text()


# Initialize properties
func _initialize_properties() -> void:
	var property_list := VBoxContainer.new()
	property_list.add_child(_create_property("name", _name_edit))
	property_list.add_child(_create_property("linked_map", _path_button))
	property_list.add_child(_create_property("linked_exit", _linked_exit_dropdown))
	
	_exit_dropdown.item_selected.disconnect(_initialize_properties)
	_name_edit.text_changed.connect(_set_name)
	_path_button.pressed.connect(_request_map_path)
	_path_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_path_button.clip_text = true
	_linked_exit_dropdown.disabled = true
	_linked_exit_dropdown.item_selected.connect(_linked_exit_selected)
	_linked_exit_dropdown.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Add editor panel
	_editor_panel.add_child(property_list)
	set_bottom_editor(_editor_panel)
	add_child(_editor_panel)


# Creates a labeled control that emulates inspector properties
func _create_property(p_name : String, p_control) -> HBoxContainer:
	var property := HBoxContainer.new()
	var property_label := Label.new()
	property_label.text = p_name
	
	for control in [property, property_label, p_control]:
		control.anchors_preset = PRESET_FULL_RECT
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	property.add_child(property_label)
	property.add_child(p_control)
	
	return property


###############
## Reloading ##
# Clear option menu, add custom controls, and sort exits by their validity
func _reload_options() -> void:
	var linked := []
	var available := []
	_indices = {}
	_exit_dropdown.clear()
	
	# Add custom controls
	_exit_dropdown.get_popup().add_icon_item(preload("res://editor/svg/ReloadSmall.svg"), "Reload")

	# Validity check
	for exit in _map.exits.values():
		var array = linked if _is_linked(exit) else available
		array.append(exit)
	
	# Add valid exits
	_exit_dropdown.add_separator("Linked")
	for exit in linked:
		_exit_dropdown.add_item(_format_name(exit))
		_indices[_exit_dropdown.item_count-1] = exit.cell
	
	# Add invalid exits
	_exit_dropdown.add_separator("Available")
	for exit in available:
		_exit_dropdown.add_item(_format_name(exit))
		_indices[_exit_dropdown.item_count-1] = exit.cell


# Set button text similar to Dictionary property editor
func _reset_options_text() -> void:
	_exit_dropdown.text = "Exit List (size " + str(_map.exits.size()) + ")"
	_exit_dropdown.icon = null


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
			selected_exit = _map.exits[_indices[index]]
			_editor_panel.show()
			_load_exit(selected_exit)


# Set option button text to exit cell and load exit properties into controls
func _load_exit(exit) -> void:
	_exit_dropdown.text = str(exit.cell)
	_name_edit.text = exit.name
	_path_button.text = ""
	_linked_exit_dropdown.selected = -1
	_linked_exit_dropdown.disabled = true
	if exit.linked_map != "":
		_linked_map_selected(exit.linked_map)
		if exit.linked_exit != Vector2i():
			var index = _linked_map.exits.keys().find(exit.linked_exit)
			_linked_exit_dropdown.select(index)



#############
## Editing ##
# Update exit dictionary to text input and marks scene as unsaved
func _set_name(new_name: String) -> void:
	selected_exit.name = new_name
	_reload_options()
	emit_changed("exits", _map.exits)
	_exit_dropdown.text = str(selected_exit.cell)


func _request_map_path() -> void:
	var dialog = FileDialog.new()
	var directory = DirAccess.open("res://")
	dialog.add_filter("*.tscn", "Maps")
	dialog.current_dir = "res://data/maps/" if directory.dir_exists("res://data/maps/") \
			else "res://data/" if directory.dir_exists("res://data/") \
			else "res://"
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.file_selected.connect(_linked_map_selected)
	add_child(dialog)
	dialog.popup(FILE_DIALOG_RECT)


func _linked_map_selected(path : String) -> void:
	selected_exit.linked_map = path
	_path_button.text = path
	_linked_exit_dropdown.clear()

	_linked_map = load(path).instantiate()
	for exit in _linked_map.exits.values():
		_linked_exit_dropdown.add_item(_format_name(exit))

	if _linked_exit_dropdown.item_count > 0:
		_linked_exit_dropdown.selected = -1
		_linked_exit_dropdown.disabled = false


func _linked_exit_selected(index : int) -> void:
	selected_exit.linked_exit = _linked_map.exits.values()[index].cell


func _format_name(exit: Dictionary) -> String:
	return str(exit.name) + " " + str(exit.cell)


func _is_linked(exit: Dictionary) -> bool:
	return true if exit.linked_map != "" and exit.linked_exit != Vector2i() else false
