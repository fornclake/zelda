extends Attack

@export var speed = 120
var velocity := Vector2.ZERO

@onready var hitbox = $Hitbox

func activate(u):
	user = u
	actor_type = user.actor_type
	
	position = user.position
	velocity = user.move_direction * speed
	
	hitbox.connect("body_entered", _on_hitbox_body_entered)

func _physics_process(delta):
	position += velocity * delta

func _on_hitbox_body_entered(body):
	if body is Actor and body.actor_type == actor_type:
		return
	queue_free()
