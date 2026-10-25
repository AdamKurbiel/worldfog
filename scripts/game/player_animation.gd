extends Node

@onready var player: CharacterBody3D = get_parent()
@onready var console: Control = player.get_node("dev/console")
@onready var anim: AnimationPlayer = player.get_node("model/AnimationPlayer")

var jump_animation_finished := false
var landing_animation := false
var walking_backwards := false


func _ready() -> void:
	var jump_animation: Animation = anim.get_animation("jump")
	jump_animation.loop_mode = Animation.LOOP_NONE


func start_jump() -> void:
	jump_animation_finished = false


func landed() -> void:
	landing_animation = true


func update_animation(
	delta: float,
	input_dir: Vector2,
	current_speed: float,
	sprinting_speed: float,
	jumping: bool
) -> void:
	var horizontal_velocity: Vector2 = Vector2(
		player.velocity.x,
		player.velocity.z
	)

	var movement_amount: float = clamp(
		horizontal_velocity.length() / sprinting_speed,
		0.0,
		1.0
	)

	var moving: bool = movement_amount > 0.05 and player.is_on_floor() and !console.visible

	if landing_animation:
		if anim.current_animation != "jump":
			anim.speed_scale = -2.0
			anim.play("jump", 0.1, 1.0, true)
		elif anim.speed_scale >= 0.0:
			anim.speed_scale = -2.0
			anim.play("jump", 0.1)

		if anim.current_animation_position <= delta:
			anim.seek(0.0, true)
			anim.pause()
			anim.speed_scale = 1.0
			landing_animation = false
			jump_animation_finished = false
	elif jumping or !player.is_on_floor():
		if !jump_animation_finished:
			if anim.current_animation != "jump":
				anim.speed_scale = 1.0
				anim.play("jump", 0.1)

			if (
				anim.current_animation_position + delta * anim.speed_scale
				>= anim.current_animation_length
			):
				anim.seek(anim.current_animation_length, true)
				anim.pause()
				jump_animation_finished = true
	elif moving:
		var move_backwards: bool = input_dir.y > 0.0

		if (
			anim.current_animation != "ArmLowAction"
			or walking_backwards != move_backwards
		):
			anim.speed_scale = 1.5
			anim.play(
				"ArmLowAction",
				0.1,
				-1.0 if move_backwards else 1.0,
				move_backwards
			)
			walking_backwards = move_backwards
	else:
		if player.is_on_floor():
			jump_animation_finished = false
			anim.speed_scale = 1.0
			anim.play("HumanLowAction", 0.1)
