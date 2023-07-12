extends Item

@onready var anim = $AnimationPlayer
@onready var hitbox = $Hitbox

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
	entity_type = user.entity_type
	user.current_state = user.state_swing
	user.connect("on_hit", queue_free)
	position = user.position
	
	anim.play(str("Swing", user.sprite_direction))
	
	var SOUNDS = [
		DEF.SFX.Sword_Slash1,
		DEF.SFX.Sword_Slash2,
		DEF.SFX.Sword_Slash3,
		DEF.SFX.Sword_Slash4,
	]
	Sound.play(SOUNDS[randi() % SOUNDS.size()])


func _on_swing_finished() -> void:
	user.current_state = user.state_default
	queue_free()


func _on_hitbox_body_entered(body) -> void:
	if body is TileMap:
		var cell = body.local_to_map(target_cell_position)
		var data : TileData = body.get_cell_tile_data(2, cell)
		if data:
			if data.get_custom_data("can_cut"):
				var effect = preload("res://effects/grass_cut.tscn").instantiate()
				body.add_child(effect)
				effect.position = body.map_to_local(cell)
				body.erase_cell(2, cell)
				Sound.play(DEF.SFX.Bush_Cut)
