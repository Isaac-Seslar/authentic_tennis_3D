extends Node3D
#
#@export var floor_tile: PackedScene
@export var grid_size = 152+90
@export var tile_spacing = 0.25
@export var floor_tile: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_floor()


func generate_floor():
	
	#var x=1
	for x in range(-grid_size, 0):
		for z in range(-grid_size+90, 0):
			var tile = floor_tile.instantiate()
			add_child(tile)
			tile.position = Vector3(x * tile_spacing, 0, z * tile_spacing)
