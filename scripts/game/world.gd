##Created by Adam Kurbiel
extends Node3D

@onready var elevator : Node3D = $elevator
@onready var player : CharacterBody3D = $player
@onready var ambient : AudioStreamPlayer3D = $elevator/ElevatorAmb

func prepareStage():
	var warmup = 5.0 #time
	
	ambient.play()
	elevator.ride()
	player.start_shake(warmup*2,0.01)
	await get_tree().create_timer(warmup).timeout
	elevator.stop()
	player.stop_shake()
	await get_tree().create_timer(1.0).timeout
	elevator.open()
	await get_tree().create_timer(0.5).timeout
	player.areaNotify("Test name")

func _ready() -> void:
	prepareStage()
