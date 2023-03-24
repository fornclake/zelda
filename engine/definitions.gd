extends Node

class Item:
	var name : String
	var icon : Texture2D
	var description : String = "An item"
	
	func _init(n = "Item", i = preload("res://ui/items/sword.png")):
		name = n
		icon = i

var ITEM = {
	Sword = Item.new("Sword"),
	Bow = Item.new("Bow"),
}
