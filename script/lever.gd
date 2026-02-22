extends Node2D

@export var ID = ""
@export var Doors = []

@export var Flipped = false

@export var Is_Overlapping = false

@export var Fail_Speech = "I'm too weak!"
@export var Can_Interact_With = ["Alien","Robot"]

@onready var Display = $AnimatedSprite2D

@onready var Area = $Area2D
var Player

func _ready() -> void:
	initialize_doors()
	Display.play("off")


func initialize_doors():
	for Child in get_parent().get_children():
		if Child.is_in_group("Door"):
			if Child.Door_ID == ID:
				Doors.append(Child)
	for Door in Doors:
		var A_Line = Line2D.new()
		var NewLine = A_Line
		NewLine.add_point(to_local(global_position))
		NewLine.add_point(to_local(Door.global_position))
		NewLine.default_color = Color.YELLOW
		NewLine.z_index = -8
		NewLine.width = 2
		add_child(NewLine)

func interaction():
	if Flipped == false:
		Flipped = true
		for Door in Doors:
			Door.State = "open"
		Display.play("on")
