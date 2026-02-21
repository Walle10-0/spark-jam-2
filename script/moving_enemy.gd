extends CharacterBody2D

@export var SPEED = 2000

@export var Target: Node = null

@onready var Nav_Agent = $NavigationAgent2D

func _ready() -> void:
	Nav_Agent.target_position = Target.global_position

func _physics_process(delta: float) -> void:
	Nav_Agent.target_position = Target.global_position
	if Nav_Agent.is_navigation_finished():
		return
	
	var current_agent_position = global_position
	var next_path_position = Nav_Agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * SPEED * delta
	
	move_and_slide()
