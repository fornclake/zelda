extends CharacterBody2D
class_name Entity

var speed = 70
var sprite_direction := "Down"

const SWORD = preload("res://entities/items/sword.tscn")

func _update_sprite_direction(vector : Vector2):
	match vector:
		Vector2.LEFT:
			sprite_direction = "Left"
		Vector2.RIGHT:
			sprite_direction = "Right"
		Vector2.UP:
			sprite_direction = "Up"
		Vector2.DOWN:
			sprite_direction = "Down"

func _use_item(item):
	var instance = item.instantiate()
	get_parent().add_child(instance)
	instance.activate(self)
