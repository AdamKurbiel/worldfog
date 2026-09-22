##Created by Adam Kurbiel
extends Control
@onready var brain_2: TextureProgressBar = $CL/Brain2
@onready var brain_2_val: RichTextLabel = $CL/Brain2Val

@onready var brain_1: TextureProgressBar = $CL/Brain1
@onready var brain_1_val: RichTextLabel = $CL/Brain1Val

@onready var roll : AudioStreamPlayer = $CL/Roll
@onready var animation : AnimationPlayer = $CL/Show

func braintransf():
	roll.stop()
	roll.pitch_scale = 0.2
	roll.play()
	for i in range(50):
		brain_1.value -= 1
		brain_2.value += 1
		brain_1_val.text = str(int(brain_1.value))+"%"
		brain_2_val.text = str(int(brain_2.value))+"%"
		await get_tree().create_timer(0.01).timeout
	roll.stop()
	await get_tree().create_timer(10).timeout
	animation.play("fadeout")

func _on_show_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadein":
		braintransf()
	if anim_name == "fadeout":
		self.queue_free()
