@tool
extends ScrollContainer

@onready var popup = %Popup
@onready var label = %Popup/Label
@onready var dim := %Popup/Dimmer

var editor_interface : EditorInterface

var highlit_rects : Array[Rect2] = []:
	set(value):
		highlit_rects = value
		_set_shader_parameters()

var tutor_rect:
	get: return get_global_rect()

var inspector_rect:
	get: return editor_interface.get_inspector().get_global_rect()


func _on_next_pressed():
	popup.position = get_window().position
	popup.size = get_window().size
	popup.popup()
	
	highlit_rects = [tutor_rect, inspector_rect]


func _set_shader_parameters(): # map dimmer's uniforms to highlit rects
	var used_rects = highlit_rects.size()
	for i in used_rects:
		dim.material.set_shader_parameter(str("rect",i), highlit_rects[i])
	for i in range(used_rects,4):
		dim.material.set_shader_parameter(str("rect",i), Rect2(0,0,0,0))
	dim.queue_redraw()
