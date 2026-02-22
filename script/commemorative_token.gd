extends Control
class_name commemorative_token

@export var Shift_ID = ""
@export var ID = 0

@export var visual: TextureRect
@export var highlight_node: Control
@export var counter: Label

var counter_num: int = 0

func update_id(new_id: String):
	Shift_ID = new_id
	update_texture()

func update_texture():
	if Shift_ID != "":
		var new_tex: Texture = load("res://textures/Shifts/Shift_"+Shift_ID+".png")
		if new_tex:
			visual.texture = new_tex

func reset_number():
	counter_num = 0
	update_number(counter_num)

func incr_number():
	counter_num += 1
	update_number(counter_num)

func update_number(number: int):
	counter.text = str(number)

func highlight(enable: bool):
	highlight_node.visible = enable
