extends CanvasLayer

signal transitioned

func _ready():
	transition()
	
func transition():
	$AnimationPlayer.play("trans-in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "trans-in":
		emit_signal("transitioned")
		$AnimationPlayer.play("trans-out")
	elif anim_name == "trans-out":
		queue_free()
