extends Node2D

@export var Door_ID = ""
@export var State = "closed"

var opened = false

@onready var Anim = $AnimatedSprite2D
@onready var Physics = $StaticBody2D

func _physics_process(delta: float) -> void:
	Anim.play(State)
	if State == "open":
		if opened == false:
			Physics.queue_free()
			opened = true
