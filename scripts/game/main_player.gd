extends CharacterBody3D

@onready var camera_controller = $head
@onready var player_animation = $PlayerAnimation
@onready var debug: Control = $dev/debug
@onready var console: Control = $dev/console
@onready var console_line: LineEdit = $dev/console/LineEdit
@onready var pauseUI = preload("res://scenes/game/pause.tscn")
@onready var areaNotifyAnimation: AnimationPlayer = $PlayerGUI/CanvasLayer/animation
@onready var areaEnterSfx: AudioStreamPlayer = $PlayerGUI/CanvasLayer/AreaEnter
@onready var areaNameLabel: Label = $PlayerGUI/CanvasLayer/area_name

var jumping = false
var current_speed: float = 5.0

var walking_speed: float = 5.0
const sprinting_speed: float = 8.0

const JUMP_VELOCITY: float = 2.5

var lerp_speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

var input_dir: Vector2 = Vector2.ZERO


func toggleFlashlight():
	$flashlight.visible = true


func areaNotify(area_name):
	areaNotifyAnimation.play("show")
	areaEnterSfx.play()
	areaNameLabel.text = area_name


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fastquit"):
		get_tree().quit()

	if event.is_action_pressed("pause") and !get_tree().paused:
		get_viewport().set_input_as_handled()
		var pause = pauseUI.instantiate()
		get_tree().root.add_child(pause)
		get_tree().paused = true

func start_shake(
	duration: float = 1.0,
	strength: float = 0.1
) -> void:
	camera_controller.start_shake(duration, strength)


func stop_shake() -> void:
	camera_controller.stop_shake()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		debug.visible = not debug.visible

	if Input.is_action_just_pressed("debug_switch"):
		if debug.visible == false:
			return
		debug.switch()

	if Input.is_action_just_pressed("toggle_console"):
		console_line.release_focus()
		console_line.text = ""
		console.visible = not console.visible

		if console.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			console_line.grab_focus()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			console_line.release_focus()

	if Input.is_action_pressed("sprint") and !console.visible:
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed

	if !is_on_floor():
		velocity += get_gravity() * delta
		jumping = true
	else:
		jumping = false

	if Input.is_action_just_pressed("jump") and is_on_floor() and !console.visible:
		velocity.y = JUMP_VELOCITY
		jumping = true
		player_animation.start_jump()

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
		camera_controller.landed()
		player_animation.landed()

	camera_controller.update_camera_movement(
		delta,
		input_dir,
		current_speed,
		sprinting_speed
	)
	player_animation.update_animation(
		delta,
		input_dir,
		current_speed,
		sprinting_speed,
		jumping
	)


func _on_line_edit_text_changed(new_text: String) -> void:
	var pos = console_line.caret_column
	console_line.text = new_text.replace("`", "")
	console_line.caret_column = pos


func _on_line_edit_text_submitted(new_text: String) -> void:
	console.visible = false
	console_line.release_focus()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	console.execute_command(new_text)
