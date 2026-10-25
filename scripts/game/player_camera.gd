extends Node3D

@onready var player: CharacterBody3D = get_parent()
@onready var console: Control = player.get_node("dev/console")
@onready var flashlight: SpotLight3D = player.get_node("flashlight")

const mouse_sens: float = 0.25

var flashlight_lerp_speed: float = 20.0

var shake_timer: float = 0.0
var shake_duration: float = 0.0
var shake_strength: float = 0.0
var shake_speed: float = 25.0
var shake_time: float = 0.0
var shake_seed: Vector3 = Vector3.ZERO

var camera_base_position: Vector3 = Vector3.ZERO
var camera_base_rotation: Vector3 = Vector3.ZERO
var camera_pitch: float = 0.0

var bob_time: float = 0.0
var bob_speed: float = 8.0
var bob_amount: float = 0.035
var sprint_bob_multiplier: float = 1.5

var camera_sway: Vector3 = Vector3.ZERO
var camera_sway_amount: float = 0.025
var camera_tilt_amount: float = 0.025

var idle_time: float = 0.0
var idle_amount: float = 0.008

var landing_amount: float = 0.0
var camera_effects_lerp: float = 10.0


func _ready() -> void:
	camera_base_position = position
	camera_base_rotation = rotation


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !console.visible:
		player.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		camera_pitch = clamp(
			camera_pitch - deg_to_rad(event.relative.y * mouse_sens),
			deg_to_rad(-89.0),
			deg_to_rad(89.0)
		)
		rotation.x = camera_pitch


func start_shake(
	duration: float = 1.0,
	strength: float = 0.1
) -> void:
	shake_duration = duration
	shake_timer = duration
	shake_strength = strength
	shake_time = 0.0

	shake_seed = Vector3(
		randf_range(0.0, 100.0),
		randf_range(0.0, 100.0),
		randf_range(0.0, 100.0)
	)


func stop_shake() -> void:
	shake_timer = 0.0


func update_camera_shake(delta: float) -> Vector3:
	if shake_timer <= 0.0:
		return Vector3.ZERO

	shake_timer -= delta
	shake_time += delta

	var progress: float = clamp(
		shake_timer / shake_duration,
		0.0,
		1.0
	)

	var fade: float = progress * progress
	var strength: float = shake_strength * fade

	var x: float = sin((shake_time * shake_speed) + shake_seed.x)
	var y: float = sin((shake_time * shake_speed * 1.17) + shake_seed.y)
	var z: float = sin((shake_time * shake_speed * 0.83) + shake_seed.z)

	return Vector3(
		x * strength,
		y * strength,
		z * strength * 0.5
	)


func landed() -> void:
	landing_amount = 0.12


func update_camera_movement(
	delta: float,
	input_dir: Vector2,
	current_speed: float,
	sprinting_speed: float
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
	var sprinting: bool = current_speed == sprinting_speed

	var target_bob_speed: float = bob_speed
	var target_bob_amount: float = bob_amount

	if sprinting:
		target_bob_speed *= sprint_bob_multiplier
		target_bob_amount *= 1.5

	if moving:
		bob_time += delta * target_bob_speed
	else:
		bob_time = lerp(bob_time, 0.0, delta * 5.0)

	var bob_x: float = sin(bob_time * 0.5) * target_bob_amount
	var bob_y: float = abs(cos(bob_time)) * target_bob_amount

	bob_x *= movement_amount
	bob_y *= movement_amount

	idle_time += delta

	var idle_y: float = 0.0
	var idle_x: float = 0.0

	if !moving:
		idle_y = sin(idle_time * 1.2) * idle_amount
		idle_x = sin(idle_time * 0.8) * idle_amount * 0.5

	var target_tilt: float = 0.0

	if moving:
		target_tilt = -input_dir.x * camera_tilt_amount

	var target_sway: Vector3 = Vector3(
		-input_dir.x * camera_sway_amount,
		0.0,
		input_dir.y * camera_sway_amount
	)

	camera_sway = camera_sway.lerp(
		target_sway,
		delta * camera_effects_lerp
	)

	landing_amount = lerp(
		landing_amount,
		0.0,
		delta * 7.0
	)

	var target_position: Vector3 = camera_base_position + Vector3(
		bob_x + idle_x + camera_sway.x,
		bob_y + idle_y - landing_amount,
		camera_sway.z
	)

	var shake_offset: Vector3 = update_camera_shake(delta)

	position = position.lerp(
		target_position + shake_offset,
		delta * camera_effects_lerp
	)

	var target_rotation: Vector3 = camera_base_rotation + Vector3(
		0.0,
		0.0,
		target_tilt
	)

	rotation.z = lerp_angle(
		rotation.z,
		target_rotation.z,
		delta * camera_effects_lerp
	)

	update_flashlight(delta)


func update_flashlight(delta: float) -> void:
	var target_rotation: Vector3 = global_rotation

	flashlight.global_rotation.x = lerp_angle(
		flashlight.global_rotation.x,
		target_rotation.x,
		delta * flashlight_lerp_speed
	)

	flashlight.global_rotation.y = lerp_angle(
		flashlight.global_rotation.y,
		target_rotation.y,
		delta * flashlight_lerp_speed
	)

	flashlight.global_rotation.z = lerp_angle(
		flashlight.global_rotation.z,
		target_rotation.z,
		delta * flashlight_lerp_speed
	)
