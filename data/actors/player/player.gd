extends Actor

var items = {
	"B": DEF.ITEM.Sword
}

var input_direction:
	get: return Input.get_vector("left", "right", "up", "down")

var last_safe_position : Vector2
var drown_instantiated := false


func _physics_process(delta) -> void:
	_state_process(delta)


func state_default() -> void:
	velocity = input_direction * speed
	move_and_slide()
	_update_sprite_direction(input_direction)
	_check_collisions()
	
	# Handle animations
	if velocity:
		if is_on_wall() and ((test_move(transform, Vector2.DOWN) and sprite_direction == "Down")
				|| (test_move(transform, Vector2.UP) and sprite_direction == "Up")
				|| (test_move(transform, Vector2.RIGHT) and sprite_direction == "Right")
				|| (test_move(transform, Vector2.LEFT) and sprite_direction == "Left")):
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


func state_swing() -> void:
	_play_animation("Swing")


func state_drown() -> void:
	# State init
	if sprite.animation != "SwimDown":
		Sound.play(DROWN_SFX)
		drown_instantiated = false
		sprite.animation = "SwimDown"
		sprite.stop()
	
	# Show drown effect. Instance frees itself
	if elapsed_state_time > 0.25 && not drown_instantiated:
		_oneshot_vfx(DROWN_VFX)
		sprite.hide()
		drown_instantiated = true
	
	# Respawn at screen start
	if elapsed_state_time > 1:
		_respawn()


func _respawn() -> void:
	position = last_safe_position
	_change_state(state_default)
	sprite.show()
	Sound.play(hit_sfx)


func _on_scroll_completed() -> void:
	last_safe_position = position
