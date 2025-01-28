class_name Pickup extends StaticBody2D

var item = Global.Item.Sword

func _ready() -> void:
	var sprite = Sprite2D.new()
	sprite.texture = item.sprite
	add_child(sprite)
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(8,8)
	collision.rotation_degrees = 45
	add_child(collision) 
	
	set_collision_layer_value(1,0)
	set_collision_layer_value(2,1)
