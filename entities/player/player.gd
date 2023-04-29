extends Entity

var items = {
	"B": DEF.ITEM.Sword
}

var input_direction:
	get: return Input.get_vector("left", "right", "up", "down")

@onready var ray = $RayCast2D


func _physics_process(delta):
	_state_process(delta)
	
	# Update ray if moving orthogonally
	if input_direction.x == 0 or input_direction.y == 0:
		ray.target_position = input_direction * 8


func state_default():
	velocity = input_direction * speed
	move_and_slide()
	
	_update_sprite_direction(input_direction)
	
	# Handle animations
	if velocity:
		if is_on_wall() and ray.is_colliding():
			_play_animation("Push")
		else:
			_play_animation("Walk")
	else:
		_play_animation("Walk")
		sprite.stop()
	
	# Handle item usage
	if Input.is_action_just_pressed("b") && items.get("B"):
		_use_item(items["B"].scene)
	elif Input.is_action_just_pressed("a") && items.get("A"):
		_use_item(items["A"].scene)


func state_swing():
	_play_animation("Swing")
