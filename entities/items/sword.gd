extends Item

@onready var anim = $AnimationPlayer

func activate(u):
	user = u
	user.current_state = user.state_swing
	position = user.position
	
	anim.play(str("Swing", user.sprite_direction))

func _on_swing_finished():
	user.current_state = user.state_default
	queue_free()
