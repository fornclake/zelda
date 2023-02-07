extends Item

@export var speed = 120
var velocity := Vector2.ZERO

@onready var hitbox = $Hitbox

func activate(u):
	user = u
	entity_type = user.entity_type
	
	position = user.position
	velocity = user.move_direction * speed
	
	hitbox.connect("body_entered", _on_hitbox_body_entered)

func _physics_process(delta):
	position += velocity * delta

func _on_hitbox_body_entered(body):
	if body is Entity and body.entity_type == entity_type:
		return
	queue_free()
