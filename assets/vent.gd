extends Node2D

@export var Is_Overlapping = false

@onready var Display = $AnimatedSprite2D

func _process(delta: float) -> void:
	if Is_Overlapping == true:
		Display.play("highlight")
	else:
		Display.play("default")
	Is_Overlapping = false
