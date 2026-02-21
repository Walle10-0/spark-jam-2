extends Node2D

@export var Vent_ID = ""
@export var Sequence_ID = 0
@export var Maximum_ID = 0

@export var Is_Overlapping = false

@export var Fail_Speech = "I'm too big!"

@export var Can_Interact_With = ["Mouse"]

@onready var Display = $AnimatedSprite2D

@onready var Area = $Area2D
var Player

const ARROW_RADIUS = 50
const LABEL_RADIUS = 30

@onready var Right_Arrow = $"Right Arrow"
@onready var Right_Label = $"Right Label"
@onready var Left_Arrow = $"Left Arrow"
@onready var Left_Label = $"Left Label"

func _process(delta: float) -> void:
	if Is_Overlapping == true:
		Display.play("highlight")
	else:
		Display.play("default")
	Is_Overlapping = false

func interaction():
	for Thing in Area.get_overlapping_areas():
		if Thing.get_parent().is_in_group("Player"):
			Player = Thing.get_parent()
	if Player.Vent_Mode == false:
		Player.Vent_Mode = true
		Player.Vents = []
		for Child in get_parent().get_children():
			if Child.is_in_group("Vent"):
				if Child.Vent_ID == Vent_ID:
					Player.Vents.append(Child)
					if Child.Sequence_ID > Maximum_ID:
						Maximum_ID = Child.Sequence_ID
		Player.Vent_Index = Sequence_ID
		Player.Vent_Max = Maximum_ID
	else:
		Player.Vent_Mode = false
		print("UNVENTEDd")

func _physics_process(delta: float) -> void:
	Right_Arrow.visible = false
	Right_Label.visible = false
	Left_Arrow.visible = false
	Left_Label.visible = false
	for Thing in Area.get_overlapping_areas():
		if Thing.get_parent().is_in_group("Player"):
			Player = Thing.get_parent()
			if Player.Vent_Mode == true:
				if Player.Vents.size() > 2:
					Right_Arrow.visible = true
					Right_Label.visible = true
					Left_Arrow.visible = true
					Left_Label.visible = true
					
					var Left_Node
					var Right_Node
					
					for New_Vent in Player.Vents:
						if Sequence_ID == 0:
							if New_Vent.Sequence_ID == Player.Vent_Max:
								Left_Node = New_Vent
							if New_Vent.Sequence_ID == Sequence_ID + 1:
								Right_Node = New_Vent
						elif Sequence_ID == Player.Vent_Max:
							if New_Vent.Sequence_ID == Sequence_ID - 1:
								Left_Node = New_Vent
							if New_Vent.Sequence_ID == 0:
								Right_Node = New_Vent
						else:
							if New_Vent.Sequence_ID == Sequence_ID - 1:
								Left_Node = New_Vent
							if New_Vent.Sequence_ID == Sequence_ID + 1:
								Right_Node = New_Vent
					
					Right_Arrow.global_position = global_position + (Right_Node.global_position-global_position).normalized()*ARROW_RADIUS
					Right_Arrow.global_rotation = (Right_Node.global_position-global_position).normalized().angle()+(PI/2)
					Right_Label.global_position = global_position + (Right_Node.global_position-global_position).normalized()*LABEL_RADIUS
					Left_Arrow.global_position = global_position + (Left_Node.global_position-global_position).normalized()*ARROW_RADIUS
					Left_Arrow.global_rotation = (Left_Node.global_position-global_position).normalized().angle()+(PI/2)
					Left_Label.global_position = global_position + (Left_Node.global_position-global_position).normalized()*LABEL_RADIUS
