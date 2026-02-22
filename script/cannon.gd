extends Node2D

@export var missile: AnimatedSprite2D
@export var launcher: AnimatedSprite2D
@export var target: Node2D
@export var missile_prefab: PackedScene = preload("res://assets/missile.tscn")
@export var Caster:Node

@export var Disengage_Timer:Node

@export var SIGHT = 300
@export var RELOAD_TIME: float = 2.0

@export var ROTATE_SPEED = 0.02

@export var DISENGAGE_TIME = 3

var disengage_counter = -1
@export var sees_player = false
@export var state = "passive"
@export var Can_See = ["Alien","Mouse","Turret"]

@onready var Emote = $Emote

var Player

var target_dir: float = 0
var reload: float = RELOAD_TIME

func _ready() -> void:
	initialize_player()

func _physics_process(delta: float) -> void:
	detection()
	if state == "passive":
		launcher.rotation += ROTATE_SPEED
	if state == "hostile":
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
	missile.rotation = launcher.rotation

func initialize_player():
	for Child in get_parent().get_children():
		if Child.is_in_group("Player"):
			Player = Child

func detection():
	Caster.target_position = Vector2(SIGHT,0)
	if Player:
		if Player.global_position.distance_to(global_position) < SIGHT:
			if Caster.is_colliding():
				if Caster.get_collider() and Caster.get_collider().is_in_group("Player"):
					if Can_See.has(Player.Form):
						sees_player = true
					else:
						sees_player = false
				else:
					sees_player = false
			else:
				sees_player = false
		else:
			sees_player = false
	
	if sees_player == true:
		disengage_counter = -1
		if state == "passive":
			state = "hostile"
			target = Player
			Emote.play("wow")
	elif sees_player == false:
		if state == "hostile":
			if disengage_counter == -1:
				disengage_counter = 0
				Disengage_Timer.start()
	if disengage_counter >= DISENGAGE_TIME:
		disengage_counter = -1
		state = "passive"
		Emote.play("wut")
	if Player.Vent_Mode == true:
		if state == "hostile":
			disengage_counter = -1
			state = "passive"
			if not Emote.is_playing():
				Emote.play("wut")

func _on_timer_timeout() -> void:
	if state == "hostile":
		disengage_counter += 1
		print("boom")
		Disengage_Timer.start()
