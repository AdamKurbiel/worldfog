extends CharacterBody3D

@export var InitialHP = 100
@export var HP = InitialHP
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
