##Created by Adam Kurbiel
extends Control

var val = 0
var del = 3.0

@onready var roll : AudioStreamPlayer = $CL/Roll
@onready var progress : TextureProgressBar = $CL/progressbar
@onready var label : RichTextLabel = $CL/consciousness_value
@onready var animation : AnimationPlayer = $CL/Show

func load_conc(value,delay):
	roll.pitch_scale = 0.2
	roll.play()
	for i in range(value):
		await get_tree().create_timer(0.01).timeout
		progress.value += 1
		label.text = str(int(progress.value)) + "%"
	roll.stop()
	await get_tree().create_timer(delay).timeout
	animation.play("fadeout")

func SetAnimVals(value,delay):
	val = value
	del = delay

func _on_show_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadein":
		roll.stop()
		load_conc(val,del)
		
	if anim_name == "fadeout":
		self.queue_free()
