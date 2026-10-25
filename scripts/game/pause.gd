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
	if event.is_action_pressed("mainmenu"):
		var menu = load("res://scenes/menu/MainMenu.tscn").instantiate()
		get_tree().root.add_child(menu)
		get_tree().root.get_node("World").queue_free()
		get_tree().paused = false
		self.queue_free()
	if event.is_action_pressed("fastquit"):
		get_tree().quit()
		

func _on_cooldown_timeout() -> void:
	canUnpause = true
