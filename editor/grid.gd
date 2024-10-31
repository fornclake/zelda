@tool
extends Node2D

const HORIZONTAL_LINES = 100
const VERTICAL_LINES = 100
const CELL_SIZE = Vector2(256, 176)
const END = 999999999999

func _draw() -> void:
	#draw_circle(Vector2.ZERO, 1000, Color.WHITE)
	for h_line in HORIZONTAL_LINES:
		draw_line(Vector2(CELL_SIZE.x * h_line, 0), Vector2(CELL_SIZE.x * h_line, END), Color.WHITE, 2)
	for v_line in VERTICAL_LINES:
		draw_line(Vector2(0, CELL_SIZE.y * v_line), Vector2(END, CELL_SIZE.y * v_line), Color.WHITE, 2)
