extends Entity

var items = {
	"B": DEF.ITEM.Sword,
}

var input_direction:
	get: return Input.get_vector("left", "right", "up", "down")

@onready var ray = $RayCast2D


func _physics_process(delta):
	_state_process(delta)
	
	if input_direction.x == 0 or input_direction.y == 0:
		ray.target_position = input_direction * 8


func state_default():
	velocity = input_direction * speed
	move_and_slide()
	
	_update_sprite_direction(input_direction)
	
	if velocity:
		if is_on_wall() and ray.is_colliding():
			set_animation("Push")
		else:
			set_animation("Walk")
	else:
		set_animation("Walk")
		sprite.stop()
	
	if Input.is_action_just_pressed("b"):
		fire_projectile(SWORD)


func state_swing():
	set_animation("Swing")
