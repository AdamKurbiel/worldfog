##Created by Adam Kurbiel
extends Control

@onready var label : RichTextLabel = $RichTextLabel
@onready var selectSound : AudioStreamPlayer = $"../../../Select"
@onready var mainMenu : Node2D = $"../../.."
@onready var prerun = preload("res://scenes/menu/prerun.tscn").instantiate()

func _on_play_mouse_entered() -> void:
	label.add_theme_color_override("default_color", Color.RED)

func _on_play_mouse_exited() -> void:
	label.remove_theme_color_override("default_color")

func _on_play_pressed(source: BaseButton) -> void:
	if source.disabled: return
	selectSound.play()
	
	match source.name:
		'play':
			get_tree().root.add_child(prerun)
			mainMenu.queue_free()
		'exit':
			get_tree().quit()
