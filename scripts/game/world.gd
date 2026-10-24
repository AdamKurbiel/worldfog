##Created by Adam Kurbiel
extends Node3D

@onready var elevator: Node3D = $elevator
@onready var player: CharacterBody3D = $player
@onready var ambient: AudioStreamPlayer3D = $elevator/ElevatorAmb
@onready var map: Node3D = $map

var CurrentStage: int = 1
var stage_skipped: bool = false
var stage_running: bool = false

var stage_name = "Prototype"


func prepareStage() -> void:
	if stage_running:
		return

	stage_running = true
	stage_skipped = false

	var warmup := 5.0

	ambient.play()
	elevator.ride()
	player.start_shake(warmup * 2.0, 0.01)

	await get_tree().create_timer(warmup).timeout
	if stage_skipped:
		return

	player.stop_shake()
	elevator.stop()

	await get_tree().create_timer(1.0).timeout
	if stage_skipped:
		return

	await openElevator()


func skipStage() -> void:
	if not stage_running or stage_skipped:
		return

	stage_skipped = true
	player.stop_shake()
	ambient.stop()

	await openElevator()


func openElevator() -> void:
	elevator.stop()
	player.stop_shake()


	elevator.open()

	await get_tree().create_timer(0.5).timeout

	player.areaNotify(stage_name)
	player.toggleFlashlight()

	await get_tree().create_timer(1.0).timeout

	$TheMoonIsWatching.play()

	var music_display = load("res://scenes/popups/music_display.tscn").instantiate()
	player.get_node("PlayerGUI").add_child(music_display)
	music_display.Show("THE MOON IS WATCHING", "Aswrek")

	stage_running = false


func _ready() -> void:
	prepareStage()
	map.Generate(elevator)
