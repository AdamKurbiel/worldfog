## Created by Adam Kurbiel
# Note: This is going to be a nightmare

extends Node3D

const TILE = preload("res://scenes/game/tile.tscn")

const HEIGHT := 3
const WIDTH := 3
const TILE_SIZE := 5

var content = []

func Generate(elevator : Node3D) -> void:
	#ways to spawn elevator:
	#1. On the wall of the map,
	#2. Centered
	var OFFSET : Vector3
	var CLEAR_POINT : Vector3
	
	OFFSET.x = (int(HEIGHT/2) * TILE_SIZE)
	OFFSET.z = (int(WIDTH/2) * TILE_SIZE)
	CLEAR_POINT.z = (int(WIDTH/2) * TILE_SIZE - OFFSET.z)
	
	content = []
	for i in range(HEIGHT):
		var row = []
		for j in range(WIDTH):
			var TILE_POSITION = Vector3(i*TILE_SIZE  - OFFSET.x,0,j*TILE_SIZE - OFFSET.z)
			
			if (TILE_POSITION != CLEAR_POINT):
				var EMPTY_TILE = TILE.instantiate()
				EMPTY_TILE.position = TILE_POSITION
				self.add_child(EMPTY_TILE)
				
				row.append(EMPTY_TILE)
				
		content.append(row)
