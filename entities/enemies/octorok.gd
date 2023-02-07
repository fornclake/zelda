extends Entity

@export var move_time : float = 1.0
@export var wait1_time : float = 1.0
@export var wait2_time : float = 1.0

var move_direction = Vector2.DOWN

const ROK = preload("res://entities/projectiles/rok.tscn")

func state_default():
	move_direction = _get_random_direction()
	change_state(state_move)

func state_move():
	if is_on_wall():
		move_direction = -move_direction
	
	velocity = move_direction * speed
	move_and_slide()
	
	_update_sprite_direction(move_direction)
	set_animation("Walk")
	
	if state_counter > move_time:
		change_state(state_wait1)

func state_wait1():
	anim.stop()
	
	if state_counter > wait1_time:
		_use_item(ROK)
		change_state(state_wait2)

func state_wait2():
	if state_counter > wait2_time:
		change_state(state_default)
