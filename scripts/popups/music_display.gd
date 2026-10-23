extends Control

@onready var fade : AnimationPlayer = $fade

func Show(song_name, author_name) -> void:
	$song_name.text = "♪ : "+song_name
	$author_name.text = author_name
	fade.play("fade")


func _on_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		self.queue_free()
