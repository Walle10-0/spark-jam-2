extends RigidBody2D

@export var fuel: GPUParticles2D
@export var explosion: GPUParticles2D
@export var speed: float = 75
@export var launch_speed: float = 50

var launch: bool = true
var end: bool = false

func _physics_process(delta: float) -> void:
	if not end:
		if launch:
			self.linear_velocity = Vector2.from_angle(self.rotation) * launch_speed
			launch = false
		self.linear_velocity += Vector2.from_angle(self.rotation) * speed * delta

func _on_body_entered(body: Node) -> void:
	if body is IAmARobot:
		body.queue_free()
	explosion.emitting = true
	fuel.emitting = false
	for child: Node in self.get_children():
		if child != fuel && child != explosion:
			child.queue_free()
		
	self.contact_monitor = false
	self.freeze = true
	self.end = true
	
	self.explosion.finished.connect(on_explosion_finish)

func on_explosion_finish():
	self.queue_free()
