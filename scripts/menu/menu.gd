##Created by Adam Kurbiel
extends Control
var target : Vector2

func _on_texture_button_pressed(type) -> void:
	match type:
		"play":
			print("Play")
		"options":
			print("Options")
		"credits":
			print("Credits")
		"exit":
			get_tree().quit()





func _on_texture_button_mouse_entered(source: Control) -> void:
	target = source.global_position
	$Node2D.look_at(target)
