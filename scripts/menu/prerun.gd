##Created by Adam Kurbiel
extends Control

var gameStart = 300
var started = false
var world = preload("res://scenes/game/world.tscn").instantiate()

@onready var fadeinTransitionAnimation : AnimationPlayer = $fadein
@onready var textLoadAnimation : AnimationPlayer = $CONTENT/loadup
@onready var textTimerBlinkAnimation : AnimationPlayer = $CONTENT/ColorRect/blink
@onready var fadeoutTransitionAnimation : AnimationPlayer = $CanvasModulate/AnimationPlayer

@onready var orchiestraHitSfx : AudioStreamPlayer = $Hit
@onready var prerunMusic : AudioStreamPlayer = $Prerun

@onready var content : Control = $CONTENT
@onready var content_subject : RichTextLabel = $CONTENT/SUBJECT

@onready var gameStartCounter : Timer = $gameStartCounter
@onready var gameStartCounterLabel : RichTextLabel = $CONTENT/timer

func _ready() -> void:
	fadeinTransitionAnimation.play("show")
	orchiestraHitSfx.play()
	
	content.visible = false
	content_subject.text = "SUBJECT: " + str(randi_range(1000,9999))

func _process(_delta: float) -> void:
	if round(fadeinTransitionAnimation.current_animation_position * 10) == 3:
		prerunMusic.play()

func _on_fadein_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		content.visible = true
		textLoadAnimation.play("load")

func fadeAway():
	if started: return
	started = true
	
	gameStartCounter.stop()
	var syringe = load("res://scenes/popups/INFO_syringe.tscn").instantiate()
	get_tree().root.add_child(syringe)
	textTimerBlinkAnimation.play("blink_endless")
	fadeoutTransitionAnimation.play("fadeout")

func _on_game_start_counter_timeout() -> void:
	if gameStart > 0:
		gameStart -= 1
		if (gameStart+1) % 10 == 0:
			textTimerBlinkAnimation.play("blink")
		gameStartCounterLabel.text = str(gameStart/10.0)
		gameStartCounter.start()
	else: fadeAway()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"): fadeAway()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeout":
		self.queue_free()
		get_tree().root.add_child(world)
