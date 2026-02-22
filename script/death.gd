extends Node2D

@onready var Dynamic_Label = $"Dynamic Label"
@onready var Anim = $AnimationPlayer

func _ready() -> void:
	Dynamic_Label.text = "The shifter ascended "+str(Global_Storage.Progress)+" floors before being contained"
	Global_Storage.Progress = 0
	Anim.play("default")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("button_1"):
		get_tree().change_scene_to_file("res://scenes/simple-level.tscn")
	if Input.is_action_pressed("button_2"):
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
