extends RigidBody2D

@export var fuel: GPUParticles2D
@export var explosion: GPUParticles2D
@export var speed: float = 75
@export var launch_speed: float = 50

var launch: bool = true

func _physics_process(delta: float) -> void:
	if launch:
		self.linear_velocity = Vector2.from_angle(self.rotation) * launch_speed
		launch = false
	self.linear_velocity += Vector2.from_angle(self.rotation) * speed * delta


func _on_body_entered(body: Node) -> void:
	
	
	explosion.reparent(self.get_parent())
	explosion.emitting = true
	self.queue_free()
