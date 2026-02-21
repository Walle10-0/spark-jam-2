extends Node2D

#Defines what kind of shift the token represents
@export var Shift_ID = ""

@onready var Collider = $Collider
@onready var Visual = $Sprite2D

func _ready():
	Visual.texture = load("res://textures/shifts/Shift_"+Shift_ID+".png")

func _on_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_shift_token(Shift_ID)
		queue_free()
