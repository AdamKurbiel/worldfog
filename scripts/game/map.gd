##Created by Adam Kurbiel
#Note: This is going to be a nightmare

extends Node3D

const HEIGHT = 3
const WIDTH = 5

@onready var tile = load("res://scenes/game/tile.tscn")
var content
var pivot = Vector2i(0,0)

func SetBlock(pos : Vector2i, object):
	content[pos.x-1][pos.y-1] = object
	print("Set " + str(object) + " on "+str(pos.x)+","+str(pos.y))

func GenerateBlock(pos : Vector2i):
	print(pos)

func FillContent():
	for i in range(len(content)):
		for j in range(len(content[i])):
			#generate blocks on empty spaces
			if str(content[i][j]) == str(0):
				GenerateBlock(Vector2i(i,j))

func Generate():
	content = []
	
	#we fillin da table
	for i in range(WIDTH):
		var row = []
		for j in range(HEIGHT):
			row.append(0)
		content.append(row)
	
	#Now lets pick the random place where elevator is placed
	#elevator is going to be used as a kind of pivot
	var elevator = get_parent().get_node("elevator")
	pivot = Vector2i(randi_range(1,WIDTH),randi_range(1,HEIGHT))
	SetBlock(pivot, elevator)
	FillContent()
