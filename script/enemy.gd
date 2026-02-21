extends PathFollow2D

@export var speed: float = 100

func _physics_process(delta: float) -> void:
	self.progress += delta * speed
