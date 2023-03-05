extends Entity

enum State {DEFAULT, SWING}

var state = State.DEFAULT
var input_vector:
	get: return Input.get_vector("left", "right", "up", "down")

@onready var ray = $RayCast2D


func _physics_process(delta):
	_state_process(delta)
	
	if input_vector.x == 0 or input_vector.y == 0:
		ray.target_position = input_vector * 8


func state_default():
	velocity = input_vector * speed
	move_and_slide()
	
	_update_sprite_direction(input_vector)
	
	if velocity:
		if is_on_wall() and ray.is_colliding():
			set_animation("Push")
		else:
			set_animation("Walk")
	else:
		set_animation("Walk")
		sprite.stop()
	
	#if Input.is_action_just_pressed("b"):
	#	_use_item(SWORD)


func state_swing():
	set_animation("Swing")
