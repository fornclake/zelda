extends CharacterBody2D
class_name Entity

const SWORD = preload("res://entities/items/sword.tscn")

@export_enum("Enemy", "Player") var entity_type

@export var hearts : float = 1.0
@export var speed : float = 70
@onready var health = hearts
var sprite_direction := "Down"
var current_state = state_default

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitbox = $Hitbox

func _ready():
	hitbox.connect("body_entered", _on_hitbox_body_entered)

func _physics_process(delta):
	current_state.call()

func state_default():
	pass

func state_hurt():
	move_and_slide()

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
	var direction = sprite_direction
	if sprite_direction in ["Left", "Right"]:
		direction = "Side"
	anim.play(str(animation, direction))

func _use_item(item):
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
		if body.entity_type == entity_type:
			return
		current_state = state_hurt
		velocity = (position - body.position).normalized() * 100
		await get_tree().create_timer(0.2).timeout
		current_state = state_default





