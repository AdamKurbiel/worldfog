##Created by Adam Kurbiel
extends Control

@onready var roll : AudioStreamPlayer = $CL/Control/Roll
@onready var progress : TextureProgressBar = $CL/Control/progressbar
@onready var labelValue : RichTextLabel = $CL/Control/strzykawa_value
@onready var animation : AnimationPlayer = $CL/Control/Show

func inject():
	roll.stop()
	roll.pitch_scale = 0.2
	roll.play()
	for i in range(100):
		progress.value -= 1
		labelValue.text = str(int(progress.value))+"%"
		await get_tree().create_timer(0.01).timeout
	roll.stop()
	await get_tree().create_timer(10).timeout
	animation.play("fadeout")

func _on_show_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadein":
		inject()
	if anim_name == "fadeout":
		self.queue_free()


func _on_timer_timeout() -> void:
	animation.play("fadeout")
