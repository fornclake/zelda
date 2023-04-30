extends Entity

var items = {
	"B": DEF.ITEM.Sword
}

var input_direction:
	get: return Input.get_vector("left", "right", "up", "down")

var last_safe_position : Vector2
var drown_instantiated := false

@onready var ray = $RayCast2D
@onready var water_detect = $WaterDetect


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
	
	if water_detect.is_colliding():
		_change_state(state_drown)


func state_swing():
	_play_animation("Swing")


func state_drown():
	# State init
	if sprite.animation != "SwimDown":
		Sound.play(DEF.SFX.Wade1)
		drown_instantiated = false
		sprite.animation = "SwimDown"
	
	sprite.frame = 1
	
	# Show drown effect. Instance frees itself
	if state_counter >= 0.25 && not drown_instantiated:
		var drown = preload("res://effects/drown.tscn").instantiate()
		add_child(drown)
		sprite.hide()
		drown_instantiated = true
	
	# Respawn at screen start
	if state_counter >= 1:
		position = last_safe_position
		_change_state(state_default)
		sprite.show()
		Sound.play(DEF.SFX.Player_Hurt)


func _on_scroll_completed():
	last_safe_position = position
