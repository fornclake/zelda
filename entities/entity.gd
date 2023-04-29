extends CharacterBody2D
class_name Entity

const SWORD = preload("res://entities/items/sword.tscn")
const SHADER = preload("res://shaders/entity.gdshader")
const DEATH_FX = preload("res://effects/enemy_death.tscn")

const KB_TIME = 0.2
const KB_AMT = 100

@export_enum("Enemy", "Player") var entity_type
@export var hearts : float = 1.0
@export var speed : float = 70
@export var damage : float = 0.5
@export var hit_sfx = preload("res://sfx/LA_Enemy_Hit.wav")
@onready var health = hearts

var sprite_direction := "Down"

var current_state = state_default
var last_state = state_default
var state_counter := 0.0

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox

signal on_hit


func _ready() -> void:
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = SHADER
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	add_to_group("entity")
	
	set_physics_process(false)


func _physics_process(delta) -> void:
	_state_process(delta)


# -------------------
# State machine stuff

func _state_process(delta) -> void:
	current_state.call()
	last_state = current_state
	state_counter += delta


func _change_state(new_state) -> void:
	current_state = new_state
	state_counter = 0


func state_default() -> void:
	pass


func state_hurt() -> void:
	sprite.material.set_shader_parameter("is_hurt", true)
	
	move_and_slide()
	
	if state_counter > KB_TIME:
		if health <= 0:
			var fx = DEATH_FX.instantiate()
			get_parent().add_child(fx)
			fx.position = position
			fx.play()
			Sound.play(DEF.SFX.Enemy_Die)
			queue_free()
		else:
			sprite.material.set_shader_parameter("is_hurt", false)
			_change_state(state_default)

# -------------------


# Sets sprite direction to last orthogonal direction.
func _update_sprite_direction(vector : Vector2) -> void:
	if vector == Vector2.LEFT:
		sprite_direction = "Left"
	elif vector == Vector2.RIGHT:
		sprite_direction = "Right"
	elif vector == Vector2.UP:
		sprite_direction = "Up"
	elif vector == Vector2.DOWN:
		sprite_direction = "Down"


# Plays an animation from a directioned set.
func _play_animation(animation : String) -> void:
	var direction = "Side" if sprite_direction in ["Left", "Right"] else sprite_direction
	sprite.play(animation + direction)
	sprite.flip_h = sprite_direction == "Left"


# Instances item and passes self as its user.
func _use_item(item) -> void:
	var instance = item.instantiate()
	get_parent().add_child(instance)
	instance.activate(self)


# Returns a random orthogonal direction.
static func _get_random_direction() -> Vector2:
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	return directions[randi() % directions.size()]


# Get hit by entities of different type
func _on_hitbox_body_entered(body) -> void:
	if body is Entity and body.entity_type != entity_type and body.damage > 0:
		hit(body.damage, body.position)


# Get hit by opposing items
func _on_hitbox_area_entered(area) -> void:
	var item = area.get_parent()
	if item is Item and item.entity_type != entity_type and item.damage > 0:
		hit(item.damage, item.position)


# Setup hit state and switch
func hit(amount, pos) -> void:
	Sound.play(hit_sfx)
	_change_state(state_hurt)
	health -= amount
	velocity = (position - pos).normalized() * KB_AMT
	emit_signal("on_hit")
