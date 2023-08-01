class_name Instance extends SubViewport

var map : Map
var player : Actor
var camera : GridCamera


func _init(map_path : String):
	map = load(map_path).instantiate()
	camera = GridCamera.new()


func _ready():
	add_child(map)
	add_child(camera)
