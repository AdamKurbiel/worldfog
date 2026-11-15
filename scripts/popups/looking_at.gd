extends RichTextLabel

@onready var eyes : RayCast3D = $"../../../head/Camera3D/eyes"

func _process(delta: float) -> void:
	text = eyes.lookingAtName
	self.modulate = eyes.textColor
