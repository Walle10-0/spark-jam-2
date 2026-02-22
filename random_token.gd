extends Node2D

var has_spawned = false

func _process(delta: float) -> void:
	if has_spawned == false:
		has_spawned = true
		var Token = load("res://assets/shift_token.tscn")
		var New_Token = Token.instantiate()
		New_Token.Shift_ID = ["Plant","Robot","Mouse","Turret"].pick_random()
		New_Token.global_position = global_position
		get_parent().add_child(New_Token)
		visible = false
