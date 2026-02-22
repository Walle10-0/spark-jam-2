extends AnimationPlayer

@export var switcher: scene_switcher
@export_file("*.tscn") var firstScene: String

func _on_animation_finished(anim_name: StringName) -> void:
	switcher.switchScene(firstScene)
