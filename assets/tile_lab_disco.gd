extends Sprite2D

@export var timer: float = 0.5

var counter: float = 0

func _process(delta: float) -> void:
	counter += delta
	if counter > timer:
		counter = 0
		flip_h = randi() % 2
		flip_v = randi() % 2
