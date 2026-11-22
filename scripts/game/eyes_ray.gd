##Created by Adam Kurbiel
#eyes system, detects anything in front of the player.
extends RayCast3D

@export var lookingAtName : String = ""
@export var textColor : Color = Color.INDIAN_RED

@onready var player = get_parent().get_parent().get_parent()

var blacklist = ["player"]

func _physics_process(delta: float) -> void:
	lookingAtName = ""
	if is_colliding():
		var collider = get_collider()
		if collider is CharacterBody3D && collider.name not in blacklist:
			lookingAtName = collider.name + " (" + str(collider.HP) + "/" + str(collider.InitialHP) + ")"
