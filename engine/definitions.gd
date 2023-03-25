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
