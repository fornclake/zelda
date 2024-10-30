extends Control

@onready var screen = $Screen

func _ready():
	var player = preload("res://data/actors/player/player.tscn").instantiate()
	var scene = GameScene.new("res://data/maps/overworld.tscn", player)
	var ui = preload("res://core/ui/ui.tscn").instantiate()
	screen.add_child(scene)
	screen.add_child(ui)
	ui.initialize(player)
