extends Attack

@export var speed = 120
var velocity := Vector2.ZERO

func activate(u):
	user = u
	actor_type = user.actor_type
	
	position = user.position
	velocity = user.move_direction * speed

func _physics_process(delta):
	position += velocity * delta
