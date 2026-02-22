extends Node2D

@onready var Anim = $AnimatedSprite2D
@export var Next_Scene = ""

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.Next_Scene(Next_Scene)
		Anim.play("closed")
