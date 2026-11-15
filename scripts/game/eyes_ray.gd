##Created by Adam Kurbiel
#eyes system, detects anything in front of the player.
extends RayCast3D

@onready var player = get_parent().get_parent().get_parent()

var blacklist = ["player"]

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider is CharacterBody3D && collider.name not in blacklist:
			print(collider.name)
