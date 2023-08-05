extends Control

@onready var screen = $Screen

func _ready():
	var player = preload("res://data/actors/player/player.tscn").instantiate()
	var overworld_instance = Instance.new("res://data/maps/overworld.tscn", player)
	screen.add_child(overworld_instance)
