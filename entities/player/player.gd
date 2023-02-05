extends Entity

@onready var ray = $RayCast2D

enum State {DEFAULT, SWING}
var state = State.DEFAULT

var input_vector = Vector2.ZERO

func _physics_process(delta):
	input_vector = _get_input_vector()
	
	current_state.call()
	
	if input_vector.x == 0 or input_vector.y == 0:
		ray.target_position = input_vector * 8
	
	sprite.flip_h = (sprite_direction == "Left")

func state_default():
	velocity = input_vector * speed
	move_and_slide()
	_update_sprite_direction(input_vector)
	
	if Input.is_action_just_pressed("b"):
		_use_item(SWORD)
	
	if velocity.length_squared() > 0:
		if is_pushing():
			set_animation("Push")
		else:
			set_animation("Walk")
	else:
		set_animation("Walk")
		anim.seek(1)

func state_swing():
	set_animation("Swing")

func _get_input_vector():
	var x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	var y = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
	return Vector2(x,y).normalized()

func is_pushing():
	if is_on_wall() and ray.is_colliding():
		return true
	return false
