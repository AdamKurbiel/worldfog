extends RichTextLabel


func tell(str) -> void:
	$".".self_modulate = Color.WHITE_SMOKE
	$".".text = str
	$AnimationPlayer.stop()
	$AnimationPlayer.play("blink")

func err(str) -> void:
	$".".self_modulate = Color.RED
	$".".text = str
	$AnimationPlayer.stop()
	$AnimationPlayer.play("blink")
