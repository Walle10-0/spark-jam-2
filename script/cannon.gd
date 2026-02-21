extends Node2D

@export var missile: AnimatedSprite2D
@export var launcher: AnimatedSprite2D
@export var target: Node2D

@export var SIGHT = 120

var target_dir: float = 0

func _physics_process(delta: float) -> void:
	if target != null:
		if self.global_position.distance_to(target.global_position) < SIGHT:
			target_dir = self.global_position.angle_to(target.global_position)
	launcher.rotation += (target_dir - launcher.rotation) * delta * 10
