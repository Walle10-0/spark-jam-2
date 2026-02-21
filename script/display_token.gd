extends Node2D

#Defines what kind of shift the token represents
@export var Shift_ID = ""
@export var ID = 0

@onready var Visual = $Sprite2D

func update_texture():
	if Shift_ID != "":
		Visual.texture = load("res://textures/Shifts/Shift_"+Shift_ID+".png")
