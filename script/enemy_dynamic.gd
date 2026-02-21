extends RigidBody2D

@export var animatedSprite: AnimatedSprite2D
@export var path_nodes: Array[Node2D]
@export var player: Character

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	var movement: Vector2 = global_position - player.global_position
	movement *= -delta
	
	self.linear_velocity += movement
	
	if abs(linear_velocity.x) > abs(linear_velocity.y):
		animatedSprite.flip_h = linear_velocity.x < 0
		animatedSprite.play("side")
	else:
		animatedSprite.flip_h = false
		if linear_velocity.y > 0:
			animatedSprite.play("front")
		else:
			animatedSprite.play("back")
	
	animatedSprite.speed_scale = linear_velocity.length() / 10
