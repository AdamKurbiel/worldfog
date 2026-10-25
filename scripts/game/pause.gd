extends Control

var canUnpause = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasLayer/cooldown.start()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and canUnpause:
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		queue_free()

func _on_cooldown_timeout() -> void:
	canUnpause = true
