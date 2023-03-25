extends Node

class ItemEntry:
	var scene : PackedScene
	var name : String
	var icon : Texture2D
	var description : String = "An item"
	
	
	func _init(item : PackedScene):
		var object = item.instantiate() # maybe we can just read the script
		scene = item
		name = object.ENTRY.name
		icon = object.ENTRY.icon
		description = object.ENTRY.description
		object.free()


var ITEM = {
	Sword = ItemEntry.new(preload("res://entities/items/sword.tscn"))
}

var SFX = {
	Enemy_Die = preload("res://sfx/LA_Enemy_Die.wav"),
	Enemy_Hit = preload("res://sfx/LA_Enemy_Hit.wav"),
	Player_Hurt = preload("res://sfx/LA_Link_Hurt.wav"),
	LowHealth = preload("res://sfx/LA_LowHealth.wav"),
	Menu_Cursor = preload("res://sfx/LA_Menu_Cursor.wav"),
	Menu_Select = preload("res://sfx/LA_Menu_Select.wav"),
	PauseMenu_Close = preload("res://sfx/LA_PauseMenu_Close.wav"),
	PauseMenu_Open = preload("res://sfx/LA_PauseMenu_Open.wav"),
	Sword_Slash1 = preload("res://sfx/LA_Sword_Slash1.wav"),
	Sword_Slash2 = preload("res://sfx/LA_Sword_Slash2.wav"),
	Sword_Slash3 = preload("res://sfx/LA_Sword_Slash3.wav"),
	Sword_Slash4 = preload("res://sfx/LA_Sword_Slash4.wav"),
}
