##Created by Adam Kurbiel
extends CharacterBody3D


@onready var head: Node3D = $head
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape
@onready var checkup: RayCast3D = $checkup
@onready var flashlight: Node3D = $flashlight
@onready var debug: Control = $debug
@onready var console: Control = $console
@onready var console_line: LineEdit = $console/LineEdit

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


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fastquit"):
		get_tree().quit()

	if event is InputEventMouseMotion:
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
	head.position = Vector3.ZERO + Vector3(0,1,0)


func update_camera_shake(delta: float) -> void:
	if shake_timer <= 0.0:
		head.position = Vector3.ZERO + Vector3(0,1,0)
		return
	
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
	
	head.position = Vector3(
		x * strength,
		y * strength + 1,
		z * strength * 0.5
	)

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug"):
		debug.visible = not debug.visible
	
	if Input.is_action_just_pressed("debug_switch"):
		if debug.visible == false: return
		debug.switch()
	
	
	#TODO move console to separate script
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

	if Input.is_action_pressed("sprint"):
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
	
	update_camera_shake(delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir: Vector2 = Input.get_vector(
		"left",
		"right",
		"forward",
		"backward"
	)


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
		
	
	if console.visible: return
	move_and_slide()


func _on_line_edit_text_changed(new_text: String) -> void:
	var pos = console_line.caret_column
	if new_text == '`':
		console_line.text = new_text.left(-1)
	console_line.text = new_text.to_upper()
	console_line.caret_column = pos
	


func _on_line_edit_text_submitted(new_text: String) -> void:
	console.visible = false
	console_line.release_focus()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	print(new_text)
