extends Node2D

const HUD_TEXTURE = preload("res://ui/hud.png")
const ITEM_B_POSITION = Vector2(8,0)
const ITEM_A_POSITION = Vector2(48,0)

var items = {}

func _draw():
	draw_texture(HUD_TEXTURE, Vector2.ZERO)
	
	if items.get("B"):
		draw_texture(items["B"].icon, ITEM_B_POSITION)
	if items.get("A"):
		draw_texture(items["A"].icon, ITEM_A_POSITION)
