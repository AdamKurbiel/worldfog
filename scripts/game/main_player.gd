
##Created by Adam Kurbiel
extends CharacterBody3D


@onready var head: Node3D = $head
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape
@onready var materialRay: RayCast3D = $materialRay
@onready var flashlight: Node3D = $flashlight
@onready var debug: Control = $debug
@onready var console: Control = $console
@onready var console_line: LineEdit = $console/LineEdit
@onready var areaNotifyAnimation : AnimationPlayer = $PlayerGUI/CanvasLayer/animation
@onready var areaEnterSfx : AudioStreamPlayer = $PlayerGUI/CanvasLayer/AreaEnter
@onready var areaNameLabel : Label = $PlayerGUI/CanvasLayer/area_name

func toggleFlashlight():
	$flashlight.visible = true

func areaNotify(area_name):
	areaNotifyAnimation.play("show")
	areaEnterSfx.play()
	areaNameLabel.text = area_name


var flashlight_lerp_speed: float = 20.0
var current_speed: float = 5.0

var walking_speed: float = 5.0
const sprinting_speed: float = 8.0

const mouse_sens: float = 0.25
const JUMP_VELOCITY: float = 2.5

var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO


var shake_timer: float = 0.0
var shake_duration: float = 0.0
var shake_strength: float = 0.0

var shake_speed: float = 25.0
var shake_time: float = 0.0

var shake_seed: Vector3 = Vector3.ZERO


var camera_base_position: Vector3 = Vector3(0, 1, 0)
var camera_base_rotation: Vector3 = Vector3.ZERO

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
var was_on_floor: bool = true

var camera_effects_lerp: float = 10.0
var input_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_base_position = head.position
	camera_base_rotation = head.rotation
	was_on_floor = is_on_floor()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fastquit"):
		get_tree().quit()

	if event is InputEventMouseMotion and !console.visible:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-89.0),
			deg_to_rad(89.0)
		)


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

	var x: float = sin(
		(shake_time * shake_speed) + shake_seed.x
	)

	var y: float = sin(
		(shake_time * shake_speed * 1.17) + shake_seed.y
	)

	var z: float = sin(
		(shake_time * shake_speed * 0.83) + shake_seed.z
	)

	return Vector3(
		x * strength,
		y * strength,
		z * strength * 0.5
	)


func update_camera_movement(delta: float) -> void:
	var horizontal_velocity: Vector2 = Vector2(
		velocity.x,
		velocity.z
	)

	var movement_amount: float = clamp(
		horizontal_velocity.length() / sprinting_speed,
		0.0,
		1.0
	)

	var moving: bool = movement_amount > 0.05 and is_on_floor() and !console.visible
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

	head.position = head.position.lerp(
		target_position + shake_offset,
		delta * camera_effects_lerp
	)

	var target_rotation: Vector3 = camera_base_rotation + Vector3(
		0.0,
		0.0,
		target_tilt
	)

	head.rotation.z = lerp_angle(
		head.rotation.z,
		target_rotation.z,
		delta * camera_effects_lerp
	)


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("debug"):
		debug.visible = not debug.visible

	if Input.is_action_just_pressed("debug_switch"):
		if debug.visible == false: return
		debug.switch()


	if Input.is_action_just_pressed("toggle_console"):
		console_line.release_focus()
		console_line.text = ""
		console.visible = not console.visible

		if (console.visible):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			console_line.grab_focus()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			console_line.release_focus()

	if Input.is_action_pressed("sprint") and !console.visible:
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed

	var target_rotation: Vector3 = head.global_rotation

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

	if !is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and !console.visible:
		velocity.y = JUMP_VELOCITY

	input_dir = Input.get_vector(
		"left",
		"right",
		"forward",
		"backward"
	)

	if console.visible:
		input_dir = Vector2.ZERO

	var target_direction: Vector3 = (
		transform.basis *
		Vector3(input_dir.x, 0.0, input_dir.y)
	).normalized()

	direction = direction.lerp(
		target_direction,
		delta * lerp_speed
	)

	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			current_speed
		)
		velocity.z = move_toward(
			velocity.z,
			0.0,
			current_speed
		)

	var floor_before_move: bool = is_on_floor()

	if self.position.y < -1000:
		return

	move_and_slide()

	if !floor_before_move and is_on_floor():
		landing_amount = 0.12

	update_camera_movement(delta)


func _on_line_edit_text_changed(new_text: String) -> void:
	var pos = console_line.caret_column
	console_line.text = new_text.replace("`", "")
	console_line.caret_column = pos


func _on_line_edit_text_submitted(new_text: String) -> void:
	console.visible = false
	console_line.release_focus()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	console.execute_command(new_text)
