extends Control

const STARTING_MAP: String = "res://data/maps/overworld.tscn"
const STARTING_ENTRANCE := Vector2i(116, 78)

@onready var screen = $Screen
@onready var player = preload("res://data/actors/player/player.tscn").instantiate()
@onready var ui = preload("res://core/ui/ui.tscn").instantiate()
var current_scene: GameScene

func _ready():
	initialize_scene(STARTING_MAP, STARTING_ENTRANCE)
	screen.add_child(ui)
	ui.initialize(player)


func initialize_scene(map, entrance):
	current_scene = GameScene.new(map, entrance, player)
	current_scene.map_changed.connect(initialize_scene)
	screen.add_child(current_scene)
