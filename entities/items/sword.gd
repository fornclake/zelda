extends Item

@onready var anim = $AnimationPlayer

func activate(u):
	user = u
	user.state = user.State.SWING
	position = user.position
	
	anim.play(str("Swing", user.sprite_direction))

func _on_swing_finished():
	user.state = user.State.DEFAULT
	queue_free()
