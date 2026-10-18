## Created by Adam Kurbiel
# Note: This is going to be a nightmare

extends Node3D

const TILE = preload("res://scenes/game/tile.tscn")

const HEIGHT := 5
const WIDTH := 5
const TILE_SIZE := 5.5

var content = []


func Generate(elevator : Node3D) -> void:
	#ways to spawn elevator:
	#1. on one of the sides of tiles (not corners), always rotated
	#to the inner way of the map,
	#2. Inside map
	
	var offset = -(int(HEIGHT/2) * TILE_SIZE)
	
	content = []
	for i in range(HEIGHT):
		var row = []
		for j in range(WIDTH):
			var EMPTY_TILE = TILE.instantiate()
			self.add_child(EMPTY_TILE)
			EMPTY_TILE.position = Vector3(i*TILE_SIZE  + (offset),0,j*TILE_SIZE)
			
			row.append(EMPTY_TILE)
		content.append(row)
		
		
	print(content)
