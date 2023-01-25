extends Entity

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var ray = $RayCast2D

enum State {DEFAULT, SWING}
var state = State.DEFAULT

func _physics_process(delta):
	var input_vector = _get_input_vector()
	
	match state:
		State.DEFAULT:
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
		
		State.SWING:
			set_animation("Swing")
	
	if input_vector.x == 0 or input_vector.y == 0:
		ray.target_position = input_vector * 8
	
	sprite.flip_h = (sprite_direction == "Left")

func _get_input_vector():
	var x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	var y = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
	return Vector2(x,y).normalized()

func set_animation(animation : String):
	var direction = sprite_direction
	if sprite_direction in ["Left", "Right"]:
		direction = "Side"
	anim.play(str(animation, direction))

func is_pushing():
	if is_on_wall() and ray.is_colliding():
		return true
	return false
