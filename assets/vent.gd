extends Node2D

@export var Is_Overlapping = false

@export var Fail_Speech = "I'm too big!"

@export var Can_Interact_With = ["Mouse"]

@onready var Display = $AnimatedSprite2D

@onready var Area = $Area2D
var Player

func _process(delta: float) -> void:
	if Is_Overlapping == true:
		Display.play("highlight")
	else:
		Display.play("default")
	Is_Overlapping = false

func interaction():
	for Thing in Area.get_overlapping_areas():
		if Thing.get_parent().is_in_group("Player"):
			Player = Thing.get_parent()
	if Player.Vent_Mode == false:
		Player.Vent_Mode = true
		print("VENTED")
	else:
		Player.Vent_Mode = false
		print("UNVENTEDd")
