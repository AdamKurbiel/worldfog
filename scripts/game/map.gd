## Created by Adam Kurbiel
# Note: This is going to be a nightmare

extends Node3D

const TILE = preload("res://scenes/game/tile.tscn")

const HEIGHT := 5
const WIDTH := 5
const TILE_SIZE := 5.2

var content = []


func Generate(elevator : Node3D) -> void:
	#ways to spawn elevator:
	#1. On the wall of the map,
	#2. Centered
	var OFFSET : Vector3 = Vector3(int(HEIGHT/2) * TILE_SIZE,0,0)
	var CLEAR_POINT : Vector3 = Vector3(int(HEIGHT/2) * TILE_SIZE - OFFSET.x,0,0)
	
	var chosenWay : int = randi_range(0,1)	
	if (chosenWay == 1):
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
