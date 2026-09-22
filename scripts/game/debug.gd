##Created by Adam Kurbiel
extends Control

#here we're getting the debug info
@onready var nameversion: RichTextLabel = $BASIC/LINE0/NAMEVERSION
@onready var fps: RichTextLabel = $BASIC/LINE1/FPS
@onready var tree_content: RichTextLabel = $TREE/LINE1/CONTENT
@onready var x_pos_label: RichTextLabel = $BASIC/LINE2/X
@onready var y_pos_label: RichTextLabel = $BASIC/LINE3/Y
@onready var z_pos_label: RichTextLabel = $BASIC/LINE4/Z

@onready var BASIC: VBoxContainer = $BASIC
@onready var TREE: VBoxContainer = $TREE

var game_version = ProjectSettings.get_setting("application/config/version")
var project_name = ProjectSettings.get_setting("application/config/name")
var godot_version = Engine.get_version_info()["string"]


var currentState = 0
func switch():
	
	"""
	Debug states:
	For me to see the useful information I created debug states,
	so I won't see all of the mess instantly on F3.
	Switch through the states/tabs using F4.
	"""
	
	var states = [
		[BASIC], 
		[BASIC, TREE]
	]

	if currentState == len(states) -1:
		currentState = 0
	else: currentState += 1
	
	for i in self.get_children():
		i.visible = false
		
	for i in states[currentState]:
		i.visible = true

func _process(_delta: float) -> void:
	if !self.visible: return
	
	nameversion.text = project_name+" V."+game_version
	
	fps.text = str(int(Engine.get_frames_per_second())) + " FPS"
	
	var player_pos = get_parent().position
	x_pos_label.text = 'X:' + str(roundf(player_pos.x * 100)/100)
	y_pos_label.text = 'Y:' + str(roundf(player_pos.y * 100)/100)
	z_pos_label.text = 'Z:' + str(roundf(player_pos.z * 100)/100)
	
	tree_content.text = get_tree().root.get_tree_string_pretty()
	
	if Input.is_action_pressed("debug_down"):
		tree_content.get_v_scroll_bar().value += 1
	if Input.is_action_pressed("debug_up"):
		tree_content.get_v_scroll_bar().value -= 1
	
