extends Item

const ENTRY = {
	name = "Sword",
	icon = preload("res://ui/items/sword.png"),
	description = "A wooden sword.",
}

@onready var anim = $AnimationPlayer

func activate(u):
	user = u
	entity_type = user.entity_type
	user.current_state = user.state_swing
	user.connect("on_hit", queue_free)
	position = user.position
	
	anim.play(str("Swing", user.sprite_direction))


func _on_swing_finished():
	user.current_state = user.state_default
	queue_free()
