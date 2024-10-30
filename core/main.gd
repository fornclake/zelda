extends Control

@onready var screen = $Screen

var current_scene: GameScene

func _ready():
	var player = preload("res://data/actors/player/player.tscn").instantiate()
	var scene = GameScene.new("res://data/maps/overworld.tscn", "Sword Cave", player)
	var ui = preload("res://core/ui/ui.tscn").instantiate()
	screen.add_child(scene)
	screen.add_child(ui)
	ui.initialize(player)
