extends Control

@onready var screen = $Screen

func _ready():
	var player = preload("res://data/actors/player/player.tscn").instantiate()
	var scene = GameScene.new("res://data/maps/overworld.tscn", player)
	screen.add_child(scene)
