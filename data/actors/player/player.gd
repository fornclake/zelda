extends Actor

var items = {}

var input_direction:
	get: return Input.get_vector("left", "right", "up", "down")

var last_safe_position : Vector2
var drown_instantiated := false
var has_entered = false
const ENTRY_DISTANCE = 64 # how far from the map entrance you must walk to exit back through it

signal item_received

func _physics_process(delta) -> void:
	_state_process(delta)
	if not has_entered:
		has_entered = position.distance_squared_to(last_safe_position) > ENTRY_DISTANCE


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
		sprite.animation = "SwimDown"
		sprite.stop()
		Sound.play(DROWN_SFX)
	
	# Show drown effect. Instance frees itself
	if elapsed_state_time > 0.25:
		sprite.hide()
		_oneshot_vfx(DROWN_VFX)
		_change_state(state_respawning)


func state_respawning() -> void:
	if elapsed_state_time >= 1:
		_respawn()


func _custom_collision(other) -> void:
	if other is Pickup:
		_pickup(other)


func _pickup(pickup) -> void:
	if items.has("B"):
		if items.has("A"):
			var slot = 0
			while items.has(slot):
				slot += 1
			items[slot] = pickup.item
		else:
			items["A"] = pickup.item
	else:
		items["B"] = pickup.item
	item_received.emit(items)
	pickup.queue_free()


func _respawn() -> void:
	has_entered = false
	position = last_safe_position
	sprite.show()
	Sound.play(hit_sfx)
	_change_state(state_default)


func _on_scroll_completed() -> void:
	last_safe_position = position
