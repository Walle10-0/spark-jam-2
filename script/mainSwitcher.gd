extends Control
class_name scene_switcher

@export_file("*.tscn") var firstScene: String
@export_file("*.tscn") var transitionTemp: String = "res://scenes/Prefabs/transition.tscn"
var saved_data = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if firstScene:
		switchScene(firstScene)

func switchScene(sceneName:String, data = null):
	var transition = load(transitionTemp).instantiate()
	add_child(transition)
	print("start transition")
	await transition.transitioned
	
	for child in get_children():
		if child != transition:
			child.queue_free()
	var newScene = load(sceneName).instantiate()
	call_deferred("add_child", newScene)
	print("new scene : " + newScene.name)
	if data != null:
		print("we have data!")
		saved_data = data
		if newScene.hasMethod("import_state"):
			newScene.import_state(saved_data)
		else:
			print("data import failed")
