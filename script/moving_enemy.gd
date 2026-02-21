extends CharacterBody2D

@export var SPEED = 200
@export var FRICTION = 20

@export var Target: Node = null

@export var animatedSprite: AnimatedSprite2D
@export var Nav_Agent: NavigationAgent2D

var bot_state: String = "_hostile"

func _ready() -> void:
	Nav_Agent.target_position = Target.global_position

func _physics_process(delta: float) -> void:
	Nav_Agent.target_position = Target.global_position
	if Nav_Agent.is_navigation_finished():
		return
	
	var current_agent_position = global_position
	var next_path_position = Nav_Agent.get_next_path_position()
	velocity += current_agent_position.direction_to(next_path_position) * SPEED * delta
	
	update_animation(velocity)
	
	move_and_slide()

func update_animation(direction: Vector2):
	if direction.length() < 1:
		animatedSprite.play("default" + bot_state)
	else:
		if abs(direction.x) > abs(direction.y):
			animatedSprite.flip_h = direction.x < 0
			animatedSprite.play("side" + bot_state)
		else:
			animatedSprite.flip_h = false
			if direction.y > 0:
				animatedSprite.play("front" + bot_state)
			else:
				animatedSprite.play("back" + bot_state)
		
		animatedSprite.speed_scale = direction.length() / 10
