extends Node2D

@onready var Anim = $"Cool Visual"

func _ready() -> void:
	Anim.play("default")
