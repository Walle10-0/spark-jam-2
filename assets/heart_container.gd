extends Node2D

@onready var Collider = $Collider

func _on_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.heal()
		queue_free()
