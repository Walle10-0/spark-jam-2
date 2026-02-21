extends CharacterBody2D
class_name Character

enum Identity {Default, Plant, Mouse, Robot, Turrent}

@export var speed: float = 300
@export var friction: float = 4
@export var identity: Identity = Identity.Default

var is_dead = false

var Health = 3
var Health_List = []
var Mouse_Health = 1
var Mouse_Health_List = []

var Form = "Alien"

#Stuff for stored tokens
var Shift_Tokens = []

@export var animatedSprite: AnimatedSprite2D
@export var Shift_Selector: Node2D
@export var Text_More: Label
@export var Text_Less: Label
@export var Interaction_Detector: Node2D
@export var Speech_Bubble: Node
@export var Speech_Timeout: Node

#Stuff for UI
var Base_Position = Vector2(-220,-130)
const SPACING = 40
var Selector_Index = 0
var ShiftOver = 0

var Health_Position = Base_Position + Vector2(-SPACING,50)

var Is_Overlapping = true
var First_Entry = true

var Vent_Mode = false
var Vents = []
var Vent_Index = 0
var Vent_Max = 0

func _ready() -> void:
	Speech_Bubble.visible = false
	initialize_display_tokens()
	initialize_health()
	update_token_display()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		interaction_check()
	if Vent_Mode == false:
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

func _physics_process(delta: float) -> void:
	check_interactables()
	update_health()
	if Vent_Mode == false:
		visible = true
		if Input.is_action_pressed("up"):
			velocity.y +=  -speed * delta
		if Input.is_action_pressed("down"):
			velocity.y +=  speed * delta
		if Input.is_action_pressed("left"):
			velocity.x +=  -speed * delta
		if Input.is_action_pressed("right"):
			velocity.x +=  speed * delta
		velocity -= velocity * delta * friction
		if Form != "Plant":
			move_and_slide()
		update_animation(velocity)
	else:
		visible = false
		if Input.is_action_just_pressed("left"):
			Vent_Index -= 1
			print("GOGOGO")
		if Input.is_action_just_pressed("right"):
			Vent_Index += 1
		if Vent_Index < 0:
			Vent_Index = Vent_Max
		if Vent_Index > Vent_Max:
			Vent_Index = 0
		for Vent in Vents:
			if Vent.Sequence_ID == Vent_Index:
				print(Vent.Sequence_ID)
				position = Vent.position

func initialize_display_tokens():
	var Display_Token = preload("res://assets/display_token.tscn")
	for n in 9:
		var New_Display_Token = Display_Token.instantiate()
		New_Display_Token.ID = n
		add_child(New_Display_Token)

func initialize_health():
	var Heart = preload("res://assets/heart.tscn")
	for n in Health:
		var New_Heart = Heart.instantiate()
		New_Heart.ID = n
		New_Heart.Type = "Health"
		New_Heart.position = Health_Position + Vector2(SPACING*n,0)
		add_child(New_Heart)
	for n in Mouse_Health:
		var New_Heart = Heart.instantiate()
		New_Heart.ID = n
		New_Heart.Type = "Mouse"
		New_Heart.position = Health_Position + Vector2(SPACING*n,0)
		New_Heart.visible = false
		add_child(New_Heart)
	for Child in get_children():
		if Child.is_in_group("Heart"):
			if Child.Type == "Health":
				Health_List.append(Child)
			if Child.Type == "Mouse":
				Mouse_Health_List.append(Child)

func get_shift_token(Shift_ID):
	Shift_Tokens.append(Shift_ID)
	update_token_display()

func use_shift_token(Remove_Index):
	if Shift_Tokens.size() > 0:
		Form = Shift_Tokens[Remove_Index]
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

func update_animation(direction: Vector2):
	if direction.length() < 1:
		animatedSprite.play(Form+"_default")
	else:
		if abs(direction.x) > abs(direction.y):
			animatedSprite.flip_h = direction.x < 0
			#animatedSprite.play("side")
			animatedSprite.play(Form+"_side")
		else:
			animatedSprite.flip_h = false
			if direction.y > 0:
				animatedSprite.play(Form+"_front")
			else:
				animatedSprite.play(Form+"_back")
		
		animatedSprite.speed_scale = direction.length() / 10

func check_interactables():
	var Valid_Count = 0
	for Area in Interaction_Detector.get_overlapping_areas():
		if Area.get_parent().is_in_group("Interactable"):
			Area.get_parent().Is_Overlapping = true
			Valid_Count += 1
	if Valid_Count == 0:
		Is_Overlapping = false
		First_Entry = true
	else:
		Is_Overlapping = true
	if Is_Overlapping == true:
		if First_Entry == true:
			character_say("E - Interact")
			First_Entry = false

func character_say(speech):
	Speech_Bubble.visible = true
	Speech_Bubble.text = speech
	Speech_Timeout.start()

func _on_speech_timer_timeout() -> void:
	Speech_Bubble.visible = false

func interaction_check():
	var Interaction_Entity
	if Is_Overlapping == true:
		for Area in Interaction_Detector.get_overlapping_areas():
			if Area.get_parent().is_in_group("Interactable"):
				Interaction_Entity = Area.get_parent()
		if Interaction_Entity.Can_Interact_With.has(Form):
			Interaction_Entity.interaction()
		else:
			character_say(Interaction_Entity.Fail_Speech)

func update_health():
	for Heart in Health_List:
		Heart.visible = false
	for Heart in Mouse_Health_List:
		Heart.visible = false
	if Form == "Mouse":
		for Heart in Mouse_Health_List:
			if Heart.ID+1 <= Mouse_Health:
				Heart.visible = true
		
		#Check for death
		if Mouse_Health <= 0:
			death()
	else:
		for Heart in Health_List:
			if Heart.ID+1 <= Health:
				Heart.visible = true
		
		#Check for death
		if Health <= 0:
			death()

func death():
	if is_dead == false:
		is_dead = true
		print("You fucking died")
