##Created by Adam Kurbiel
extends Control

#Note: this is very hardcoded.

var intro = [
	"BODY FUSION IN PROGRESS.",
	"CHECKING CONSCIOUSNESS LEVEL..",
	"...",
	"READY TO REPLICATE.",
	"STAND STILL AND DO NOT WAKE UP."
]

@onready var content : RichTextLabel = $content
@onready var write : AudioStreamPlayer = $Write
@onready var MENU : Node2D = preload("res://scenes/menu/MainMenu.tscn").instantiate()

func skip():
	get_tree().root.add_child(MENU)
	self.queue_free()

func type(text):
	content.text = content.text + "\n"
	for i in text:
		content.text = content.text + i
		if i != ' ':
			write.stop()
			write.play()
		await get_tree().create_timer(0.05).timeout
	if text == "...":
		const INFO_CONSCIOUSNESS = preload("uid://b1vmmqo0sr2bb")
		var info = INFO_CONSCIOUSNESS.instantiate()
		add_child(info)
		info.SetAnimVals(60,10.0)
	elif text == "READY TO REPLICATE.":
		const INFO_BRAINCONTROL = preload("uid://dydd5jg3yg6d0")
		var info = INFO_BRAINCONTROL.instantiate()
		add_child(info)
	elif text == "STAND STILL AND DO NOT WAKE UP.":
		const INFO_INJECT = preload("uid://bridcmapirhyp")
		var info = INFO_INJECT.instantiate()
		info.get_node("CL/Control").position = Vector2(350,-40)
		add_child(info)
	await get_tree().create_timer(1).timeout
	return true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		skip()
		
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	
	for i in intro:
		await type(i)
	await get_tree().create_timer(2).timeout
	
	skip()
