extends Node2D

@onready var Anim = $"Cool Visual"
@onready var Fader = $AnimationPlayer
var has_clicked = false
var type_click = ""

func _ready() -> void:
	Anim.play("default")


func _on_play_button_button_up() -> void:
	if has_clicked == false:
		has_clicked = true
		Fader.play("fade_out")
		type_click = "Play"


func _on_quit_button_button_up() -> void:
	if has_clicked == false:
		has_clicked = true
		Fader.play("fade_out")
		type_click = "Quit"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if type_click == "Play":
			get_tree().change_scene_to_file("res://scenes/prelude.tscn")
		elif type_click == "Quit":
			get_tree().quit()
