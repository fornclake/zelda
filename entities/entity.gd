extends CharacterBody2D
class_name Entity

const SWORD = preload("res://entities/items/sword.tscn")
const SHADER = preload("res://shaders/entity.gdshader")
const DEATH_FX = preload("res://effects/enemy_death.tscn")

const KB_TIME = 0.25
const KB_AMT = 75

@export_enum("Enemy", "Player") var entity_type
@export var hearts : float = 1.0
@export var speed : float = 70
@export var damage : float = 0.5
@onready var health = hearts
var sprite_direction := "Down"

var current_state = state_default
var last_state = state_default
var state_counter := 0.0

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox

signal on_hit


func _ready():
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = SHADER
	hitbox.connect("body_entered", _on_hitbox_body_entered)
	hitbox.connect("area_entered", _on_hitbox_area_entered)
	add_to_group("entity")
	
	set_physics_process(false)


func _physics_process(delta):
	_state_process(delta)


func _state_process(delta):
	current_state.call()
	last_state = current_state
	state_counter += delta


func change_state(new_state):
	current_state = new_state
	state_counter = 0


func state_default():
	pass


func state_hurt():
	sprite.material.set_shader_parameter("is_hurt", true)
	
	move_and_slide()
	
	if state_counter > KB_TIME:
		if health <= 0:
			var fx = DEATH_FX.instantiate()
			get_parent().add_child(fx)
			fx.position = position
			fx.play()
			queue_free()
		
		sprite.material.set_shader_parameter("is_hurt", false)
		change_state(state_default)


func _update_sprite_direction(vector : Vector2):
	match vector:
		Vector2.LEFT:
			sprite_direction = "Left"
		Vector2.RIGHT:
			sprite_direction = "Right"
		Vector2.UP:
			sprite_direction = "Up"
		Vector2.DOWN:
			sprite_direction = "Down"


func set_animation(animation : String):
	var direction = "Side" if sprite_direction in ["Left", "Right"] else sprite_direction
	sprite.play(animation + direction)
	sprite.flip_h = sprite_direction == "Left"


func use_item(item):
	var instance = item.instantiate()
	get_parent().add_child(instance)
	instance.activate(self)


func _get_random_direction():
	var rng = randi() % 4
	match rng:
		0:
			return Vector2.LEFT
		1:
			return Vector2.RIGHT
		2:
			return Vector2.UP
		3:
			return Vector2.DOWN


func _on_hitbox_body_entered(body):
	if body is Entity:
		if body.entity_type != entity_type and body.damage > 0:
			hit(body.damage, body.position)


func _on_hitbox_area_entered(area):
	var item = area.get_parent()
	if item is Item:
		if item.entity_type != entity_type and item.damage > 0:
			hit(item.damage, item.position)


func hit(amount, pos):
	change_state(state_hurt)
	health -= amount
	velocity = (position - pos).normalized() * KB_AMT
	emit_signal("on_hit")
