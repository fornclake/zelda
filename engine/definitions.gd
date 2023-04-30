extends Node

class ItemEntry:
	var scene : PackedScene
	var name : String
	var icon : Texture2D
	var description : String = "An item"
	
	func _init(resource : ItemResource):
		scene = resource.scene
		name = resource.name
		icon = resource.icon
		description = resource.description


var ITEM = {
	Sword = ItemEntry.new(preload("res://ui/items/sword.tres"))
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
	Bush_Cut = preload("res://sfx/LA_Bush_Cut.wav"),
	Wade1 = preload("res://sfx/LA_Link_Wade1.wav"),
	Wade2 = preload("res://sfx/LA_Link_Wade2.wav"),
}
