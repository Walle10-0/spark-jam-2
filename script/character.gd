extends CharacterBody2D
class_name Character

enum Identity {Default, Plant, Mouse, Robot, Turrent}

@export var speed: float = 300
@export var friction: float = 4
@export var identity: Identity = Identity.Default

var Form = "Alien"

#Stuff for stored tokens
var Shift_Tokens = []

@onready var Shift_Selector = $ShiftSelector
@export var Text_More: Label
@export var Text_Less: Label
#@onready var Text_More = $MoreText
#@onready var Text_Less = $LessText

#Stuff for UI
var Base_Position = Vector2(-220,-130)
const SPACING = 40
var Selector_Index = 0
var ShiftOver = 0

func _ready() -> void:
	initialize_display_tokens()
	update_token_display()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shift"):
		use_shift_token(Selector_Index)
	if Input.is_action_just_pressed("button_1"):
		if Shift_Tokens.size()>=1:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(0)
	elif Input.is_action_just_pressed("button_2"):
		if Shift_Tokens.size()>=2:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(1)
	elif Input.is_action_just_pressed("button_3"):
		if Shift_Tokens.size()>=3:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(2)
	elif Input.is_action_just_pressed("button_4"):
		if Shift_Tokens.size()>=4:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(3)
	elif Input.is_action_just_pressed("button_5"):
		if Shift_Tokens.size()>=5:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(4)
	elif Input.is_action_just_pressed("button_6"):
		if Shift_Tokens.size()>=6:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(5)
	elif Input.is_action_just_pressed("button_7"):
		if Shift_Tokens.size()>=7:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(6)
	elif Input.is_action_just_pressed("button_8"):
		if Shift_Tokens.size()>=8:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(7)
	elif Input.is_action_just_pressed("button_9"):
		if Shift_Tokens.size()>=9:
			if Selector_Index > 8:
				use_shift_token(Selector_Index-8)
			else:
				use_shift_token(8)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if event.is_released():
				if Selector_Index < Shift_Tokens.size()-1:
					Selector_Index += 1
				update_token_display()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if event.is_released():
				Selector_Index -= 1
				if Selector_Index <= 0:
					Selector_Index = 0
				update_token_display()
		print(Selector_Index)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		velocity.y +=  -speed * delta
	if Input.is_action_pressed("down"):
		velocity.y +=  speed * delta
	if Input.is_action_pressed("left"):
		velocity.x +=  -speed * delta
	if Input.is_action_pressed("right"):
		velocity.x +=  speed * delta
	velocity -= velocity * delta * friction
	move_and_slide()

func initialize_display_tokens():
	var Display_Token = preload("res://assets/display_token.tscn")
	for n in 9:
		var New_Display_Token = Display_Token.instantiate()
		New_Display_Token.ID = n
		add_child(New_Display_Token)

func get_shift_token(Shift_ID):
	Shift_Tokens.append(Shift_ID)
	update_token_display()

func use_shift_token(Remove_Index):
	Form = Shift_Tokens[Remove_Index]
	print(Form)
	if Selector_Index == Shift_Tokens.size()-1:
		Shift_Tokens.remove_at(Remove_Index)
		Selector_Index -= 1
	else:
		Shift_Tokens.remove_at(Remove_Index)
	if Selector_Index < 0:
		Selector_Index = 0
	update_token_display()

func update_token_display():
	if Shift_Tokens.size() < 9:
		Text_Less.visible = false
		Text_More.visible = false
	else:
		if Selector_Index <= 8:
			Text_Less.visible = false
			Text_More.visible = true
			Text_More.text = "+"+str(Shift_Tokens.size()-9)
			if Text_More.text == "+0":
				Text_More.visible = false
		elif Selector_Index != Shift_Tokens.size()-1:
			Text_Less.visible = true
			Text_More.visible = true
			Text_Less.text = "+"+str(Selector_Index+1-9)
			Text_More.text = "+"+str(Shift_Tokens.size()-Selector_Index-1)
		else:
			Text_Less.visible = true
			Text_More.visible = false
			Text_Less.text = "+"+str(Selector_Index+1-9)
	if Shift_Tokens.size() == 0:
		Shift_Selector.visible = false
	else:
		Shift_Selector.visible = true
	if Selector_Index < 9 && Shift_Tokens.size() > 0:
		Shift_Selector.position = Base_Position + Vector2(SPACING*(Selector_Index),0)
	if Shift_Tokens.size() > 9:
		for Display_Index in 9:
			for Child in get_children():
				if Child.is_in_group("Display Token"):
					if Child.ID == Display_Index:
						if Selector_Index > 8:
							Child.Shift_ID = Shift_Tokens[Selector_Index-9+Display_Index+1]
						else:
							Child.Shift_ID = Shift_Tokens[Display_Index]
						Child.visible = true
	elif Shift_Tokens.size() == 0:
		for Child in get_children():
			if Child.is_in_group("Display Token"):
				Child.visible = false
	elif Shift_Tokens.size() <= 9:
		for Display_Index in Shift_Tokens.size():
			for Child in get_children():
				if Child.is_in_group("Display Token"):
					if Child.ID <= Shift_Tokens.size():
						Child.visible = true
					else:
						Child.visible = false
					if Child.ID == Display_Index:
						Child.Shift_ID = Shift_Tokens[Display_Index]
	for Child in get_children():
		if Child.is_in_group("Display Token"):
			if Child.ID > Shift_Tokens.size()-1:
				Child.visible = false
			Child.position = Base_Position + Vector2(SPACING*Child.ID,0)
			Child.update_texture()
