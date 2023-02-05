extends Entity

@export var move_time : float = 1.0
@export var wait_time : float = 1.0

var counter = 0
var move_direction = Vector2.DOWN

func state_default():
	var delta = get_physics_process_delta_time()
	counter += delta
	if counter < move_time:
		velocity = move_direction * speed
		move_and_slide()
		set_animation("Walk")
	elif counter > move_time + wait_time:
		move_direction = _get_random_direction()
		counter = 0
	else:
		anim.stop()
	
	_update_sprite_direction(move_direction)
	sprite.flip_h = sprite_direction == "Left"
	
	if is_on_wall():
		move_direction = -move_direction
	
