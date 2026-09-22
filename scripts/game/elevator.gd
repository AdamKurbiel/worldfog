##Created by Adam Kurbiel
extends Node3D

@onready var outerWall: MeshInstance3D = $outerWalls/wall0
@onready var animation: AnimationPlayer = $animation
@onready var rollSound: AudioStreamPlayer3D = $gate/Roll
@onready var elevatorAmbient: AudioStreamPlayer3D = $ElevatorAmb

var elevatorSpeed : float = 0.5 
var working : bool = false
var walls_moving_material : ShaderMaterial

func _ready() -> void:
	walls_moving_material = outerWall.material_override as ShaderMaterial
	
func open():
	animation.play("open")
	elevatorAmbient.stop()
	elevatorAmbient.pitch_scale = 1.06
	rollSound.play()
	
func ride():
	working = true

func stop():
	working = false
	$ElevatorAmb/pitchAnim.play("stop")
	

func _process(_delta: float) -> void:
	if (!working):
		elevatorSpeed = lerpf(elevatorSpeed, 0,0.01)
	else:
		elevatorSpeed = lerpf(elevatorSpeed, 0.5,0.005)
	walls_moving_material.set_shader_parameter("speed", elevatorSpeed)

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		rollSound.stop()
