## Created by Adam Kurbiel
# Note: This is going to be a nightmare

extends Node3D

const HEIGHT := 3
const WIDTH := 5
const TILE_SIZE := 6

const TILE = preload("res://scenes/game/tile.tscn")

func Generate(elevator : Node3D) -> void:
	print(elevator.name)
