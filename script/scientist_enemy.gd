extends CharacterBody2D

@export var SPEED = 180
@export var FRICTION = 3
@export var SIGHT = 0

@export var ATTACK_RANGE = 40
@export var DAMAGE = 1

@export var FOV = 45

@export var VIEW_RANGE = 150
@export var VIEW_ANGLE = 0

var Rotation_State = Vector2(0,1)
var Sees_Player = false
var Has_Broken_Sight = false
var Last_Seen_ID = ""
var Player

@export var Can_See = ["Alien","Mouse","Turret","Scientist"]
@onready var LaserText = $Label

@export var Waypoint_ID = ""
@export var Waypoint_List = []
var Waypoint_Index = 0
var Waypoint_Max = 0
@export var WAYPOINT_DISTANCE = 10

@export var Target: Node2D = null

@export var animatedSprite: AnimatedSprite2D
@export var Nav_Agent: NavigationAgent2D
@export var Caster:Node

@onready var Emote = $Callouts

@onready var LaserAnim = $LaserAnim

var bot_state: String = "_passive"

var disablethistemp = true

func _ready() -> void:
	initialize_player()
	initialize_Waypoints()

func _physics_process(delta: float) -> void:
	detection()
	
	
	if bot_state == "_passive":
		if Waypoint_List.size() > 0:
			for Waypoint in Waypoint_List:
				if Waypoint_Index != Waypoint_Max:
					if Waypoint.Sequence_ID == Waypoint_Index+1:
						Target = Waypoint
				else:
					if Waypoint.Sequence_ID == 0:
						Target = Waypoint
			if global_position.distance_to(Target.global_position) < WAYPOINT_DISTANCE:
				Waypoint_Index += 1
				if Waypoint_Index > Waypoint_Max:
					Waypoint_Index = 0
	elif bot_state == "_hostile":
		Target = Player
		
	
	if disablethistemp == false:
		if self.global_position.distance_to(Target.global_position) < SIGHT:
			bot_state = "_hostile"
			
			
		else:
			bot_state = "_passive"
	
	# navigate to target
	Nav_Agent.target_position = Target.global_position
	
	if not Nav_Agent.is_navigation_finished():
		var current_agent_position = global_position
		var next_path_position = Nav_Agent.get_next_path_position()
		self.velocity += current_agent_position.direction_to(next_path_position) * SPEED * delta
	
	# physics stuff
	
	self.velocity -= self.velocity * FRICTION * delta
	
	update_animation(velocity)
	
	move_and_slide()

func update_animation(direction: Vector2):
	if LaserAnim.is_playing() == false:
		LaserText.visible = false
	else:
		LaserText.visible = true
	if direction.length() < 1:
		animatedSprite.play("default" + bot_state)
	else:
		if abs(direction.x) > abs(direction.y):
			animatedSprite.flip_h = direction.x < 0
			animatedSprite.play("side" + bot_state)
			if direction.x < 0:
				Rotation_State = Vector2(-1,0)
			else:
				Rotation_State = Vector2(1,0)
		else:
			animatedSprite.flip_h = false
			if direction.y > 0:
				animatedSprite.play("front" + bot_state)
				Rotation_State = Vector2(0,1)
			else:
				animatedSprite.play("back" + bot_state)
				Rotation_State = Vector2(0,-1)
		
		animatedSprite.speed_scale = direction.length() / 10

func initialize_Waypoints():
	for Child in get_parent().get_children():
		if Child.is_in_group("Waypoint"):
			if Child.Waypoint_ID == Waypoint_ID:
				Waypoint_List.append(Child)
				if Child.Sequence_ID > Waypoint_Max:
					Waypoint_Max = Child.Sequence_ID

func initialize_player():
	for Child in get_parent().get_children():
		if Child.is_in_group("Player"):
			Player = Child

func detection():
	if Player:
		if Player.global_position.distance_to(global_position) < VIEW_RANGE:
			Caster.target_position = to_local(Player.global_position)
			if Caster.is_colliding():
				if Caster.get_collider() and Caster.get_collider().is_in_group("Player"):
					if (Player.global_position-global_position).dot(Rotation_State) > 0:
						if Player.Vent_Mode == false:
							Sees_Player = true
						else:
							Sees_Player = false
					else:
						Sees_Player = false
				else:
					Sees_Player = false
	
	if bot_state == "_passive":
		if Sees_Player == true:
			#become hostile
			if Can_See.has(Player.Form):
				bot_state = "_hostile"
				if not Emote.is_playing():
					Emote.play("wow")
	elif bot_state == "_hostile":
		if Sees_Player == false:
			if Has_Broken_Sight == false:
				Has_Broken_Sight = true
				Last_Seen_ID = Player.Form
		if Sees_Player == true:
			if Has_Broken_Sight == true:
				Has_Broken_Sight = false
				if Player.Form != Last_Seen_ID:
					if not Can_See.has(Player.Form):
						bot_state = "_passive"
						if not Emote.is_playing():
							Emote.play("wut")
	if Player.Vent_Mode == true:
		if bot_state == "_hostile":
			bot_state = "_passive"
			if not Emote.is_playing():
				Emote.play("wut")


func _on_attack_timer_timeout() -> void:
	if bot_state == "_hostile":
		if Player:
			if Player.global_position.distance_to(global_position) < ATTACK_RANGE:
				if Sees_Player == true:
					if LaserAnim.is_playing() == false:
						LaserAnim.play("Laser")
						Player.damage(DAMAGE)
