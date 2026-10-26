extends Control

@onready var text = $Label
@onready var bar = $stability_bar

var shadowMaterial: ShaderMaterial
var shadowDistance: float = 0.0

var unstability = 0.0
var render_u = 0.0
@export var lerp_speed = 5.0

func _ready() -> void:
	shadowMaterial = text.material as ShaderMaterial

func shake():
	shadowDistance = 0.5

func rm(n):
	if unstability + n > 100:
		unstability = 100
		return
	unstability += n
	shake()
	
func add(n):
	if unstability - n < 0:
		unstability = 0
		return
	unstability -= n
	shake()

func forceset(n):
	if n < 0 || n > 100: return
	unstability = n
	shake()
	
func _process(delta: float) -> void:
	var weight = 1.0 - exp(-lerp_speed * delta)

	shadowDistance = lerpf(shadowDistance, 0.0, weight)
	shadowMaterial.set_shader_parameter("shadow_distance", shadowDistance)

	render_u = lerpf(render_u, unstability, weight)

	bar.value = render_u
	text.text = str(int(100.0 - render_u)) + "% STABILITY"
