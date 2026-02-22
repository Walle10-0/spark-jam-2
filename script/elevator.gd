extends Node2D

@onready var Anim = $AnimatedSprite2D
@export var Next_Scene = ""
@export var Game_Ender = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.Next_Scene(Next_Scene)
		if Game_Ender == true:
			Global_Storage.Game_Over = true
		Anim.play("closed")
