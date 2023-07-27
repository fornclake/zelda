extends Attack

@onready var anim = $AnimationPlayer
@onready var hitbox = $Hitbox

const SOUNDS = [
	preload("res://data/sfx/LA_Sword_Slash1.wav"),
	preload("res://data/sfx/LA_Sword_Slash2.wav"),
	preload("res://data/sfx/LA_Sword_Slash3.wav"),
	preload("res://data/sfx/LA_Sword_Slash4.wav"),
]

var target_cell_position : Vector2i:
	get:
		var user_cell = user.position.snapped(Vector2(8, 8))
		
		match user.sprite_direction:
			"Left":
				return user_cell + Vector2(-24, 0)
			"Right":
				return user_cell + Vector2(16, 0)
			"Up":
				return user_cell + Vector2(-8, -16)
			"Down":
				return user_cell + Vector2(0, 16)
		
		return user_cell


func activate(u) -> void:
	user = u
	actor_type = user.actor_type
	user.current_state = user.state_swing
	user.connect("on_hit", queue_free)
	position = user.position
	
	anim.play(str("Swing", user.sprite_direction))
	Sound.play(SOUNDS[randi() % SOUNDS.size()])


func _on_swing_finished() -> void:
	user.current_state = user.state_default
	queue_free()


func _on_hitbox_body_entered(body) -> void:
	if body is Map:
		var cell = body.local_to_map(target_cell_position)
		body.slash(cell)
