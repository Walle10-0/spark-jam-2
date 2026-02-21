extends CharacterBody2D
class_name Character

enum Identity {Default, Plant, Mouse, Robot, Turrent}

@export var speed: float = 300
@export var friction: float = 4
@export var identity: Identity = Identity.Default

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		velocity.y +=  -speed * delta
	if Input.is_action_pressed("down"):
		velocity.y +=  speed * delta
	if Input.is_action_pressed("left"):
		velocity.x +=  -speed * delta
	if Input.is_action_pressed("right"):
		velocity.x +=  speed * delta
	velocity -= velocity * delta * friction
	move_and_slide()
