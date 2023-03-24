extends Node2D

const HUD_TEXTURE = preload("res://ui/hud.png")
const ITEM_B_POSITION = Vector2(8,0)
const ITEM_A_POSITION = Vector2(48,0)

var target

func initialize(t):
	target = t

func _draw():
	draw_texture(HUD_TEXTURE, Vector2.ZERO)
	
	if target.items.size() >= 1:
		draw_texture(target.items[0].icon, ITEM_B_POSITION)
	if target.items.size() >= 2:
		draw_texture(target.items[1].icon, ITEM_A_POSITION)
