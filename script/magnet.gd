extends Node2D

@export var DAMAGE = 1
@export var Magnet_Range = 50
var Player
var Robots = []

@onready var Explosion = preload("res://assets/explosion.tscn")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	Robots = []
	for Child in get_parent().get_children():
		if Child.is_in_group("Player"):
			Player = Child
		if Child.is_in_group("Robot"):
			Robots.append(Child)
	for Robot in Robots:
		if global_position.distance_to(Robot.global_position) < Magnet_Range:
			var New_Explosion = Explosion.instantiate()
			New_Explosion.global_position = Robot.global_position
			Robots.erase(Robot)
			Robot.queue_free()
			get_parent().add_child(New_Explosion)
	if global_position.distance_to(Player.global_position) < Magnet_Range:
		if Player.Form == "Robot":
			var New_Explosion = Explosion.instantiate()
			Player.Form = "Alien"
			Player.damage(DAMAGE)
			New_Explosion.global_position = Player.global_position
			get_parent().add_child(New_Explosion)
