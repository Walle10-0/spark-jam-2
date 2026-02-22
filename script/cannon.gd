extends Node2D

@export var missile: AnimatedSprite2D
@export var launcher: AnimatedSprite2D
@export var target: Node2D
@export var missile_prefab: PackedScene = preload("res://assets/missile.tscn")

@export var SIGHT = 240
@export var RELOAD_TIME: float = 2.0

var target_dir: float = 0
var reload: float = RELOAD_TIME

func _physics_process(delta: float) -> void:
	if target != null:
		if self.global_position.distance_to(target.global_position) < SIGHT:
			target_dir = self.global_position.angle_to_point(target.global_position)
			if reload > RELOAD_TIME and abs(launcher.rotation - target_dir) < 1:
				var new_shot: Node2D = missile_prefab.instantiate()
				self.get_parent().add_child(new_shot)
				new_shot.rotation = launcher.rotation
				new_shot.global_position = launcher.global_position
				reload = 0
	launcher.rotation = target_dir
	missile.rotation = target_dir
	reload += delta
	if reload > RELOAD_TIME:
		missile.visible = true
	else:
		missile.visible = false
