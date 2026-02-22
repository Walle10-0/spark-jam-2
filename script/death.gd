extends Node2D

@onready var Dynamic_Label = $"Dynamic Label"
@onready var Anim = $AnimationPlayer

func _ready() -> void:
	Dynamic_Label.text = "The shifter ascended "+str(Global_Storage.Progress)+" floors before being contained"
	Global_Storage.Progress = 0
	Anim.play("default")
