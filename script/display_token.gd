extends Node2D

#Defines what kind of shift the token represents
@export var Shift_ID = ""
@export var ID = 0

@onready var Visual = $Sprite2D

func update_texture():
	Visual.texture = load("res://textures/shifts/Shift_"+Shift_ID+".png")
