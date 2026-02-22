extends Node2D

var has_spawned = false

func _process(delta: float) -> void:
	if has_spawned == false:
		has_spawned = true
		var selection = ["Plant","Robot","Mouse","Turret","Scientist", "Health"].pick_random()
		if selection == "Health":
			var Token = load("res://assets/heart-container.tscn")
			var New_Token = Token.instantiate()
			New_Token.global_position = global_position
			get_parent().add_child(New_Token)
		else:
			var Token = load("res://assets/shift_token.tscn")
			var New_Token = Token.instantiate()
			New_Token.Shift_ID = selection
			New_Token.global_position = global_position
			get_parent().add_child(New_Token)
		visible = false
