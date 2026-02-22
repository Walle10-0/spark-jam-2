extends AnimationPlayer

@export_file("*.tscn") var firstScene: String

func _on_animation_finished(anim_name: StringName) -> void:
	print("WE'RE DONE")
	if firstScene:
		get_tree().change_scene_to_file(firstScene)
	else:
		get_tree().quit()
