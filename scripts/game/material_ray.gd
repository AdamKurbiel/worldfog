##Created by Adam Kurbiel
#Footsteps system
extends RayCast3D

var FOOTSTEP_SOUNDS = {
	"default": {
		"stream": AudioStreamMP3.new().load_from_file("res://audio/sfx/footsteps_default.mp3"),
		"interval": 0.40
	},
	"metal": {
		"stream": AudioStreamMP3.new().load_from_file("res://audio/sfx/footsteps_metal.mp3"),
		"interval": 0.40
	}
}

@onready var player = get_parent()
@onready var footsteps: AudioStreamPlayer3D = $footsteps

var chosenSound: Dictionary = FOOTSTEP_SOUNDS["default"]

var footstep_timer := 0.0
var footstep_interval: float = chosenSound["interval"]

var was_moving := false


func _ready() -> void:
	footsteps.bus = "GAME"
	footsteps.stream = chosenSound["stream"]


func setMaterialSound() -> void:
	if !is_colliding():
		return

	var material: String = get_collider().get_meta("material", "default")

	if !FOOTSTEP_SOUNDS.has(material):
		material = "default"

	var new_sound: Dictionary = FOOTSTEP_SOUNDS[material]

	if chosenSound == new_sound:
		return

	chosenSound = new_sound

	footsteps.stream = chosenSound["stream"]
	footstep_interval = chosenSound["interval"]


func _process(delta: float) -> void:
	setMaterialSound()

	var moving: bool = Vector2(
		player.velocity.x,
		player.velocity.z
	).length() > 0.15

	var grounded: bool = player.is_on_floor()

	if !moving or !grounded:
		footstep_timer = 0.0
		footsteps.stop()
		was_moving = false
		return

	if !was_moving:
		footstep_timer = footstep_interval
		was_moving = true

	footstep_timer += delta

	if footstep_timer >= footstep_interval:
		footstep_timer = 0.0

		footsteps.pitch_scale = randf_range(1.30, 1.40)
		footsteps.play(0.05)
