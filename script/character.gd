extends CharacterBody2D
class_name Character

@export_subgroup("Stats")
@export var Health = 3
@export var speed: float = 300
@export var friction: float = 4

@export_subgroup("Links")
@export var animatedSprite: AnimatedSprite2D
@export var Shift_Selector: Node2D
@export var Interaction_Detector: Node2D
@export var Speech_Bubble: Node
@export var Speech_Timeout: Node
@export var camera: Camera2D

@export_subgroup("Missile")
@export var missile_prefab: PackedScene = preload("res://assets/missile.tscn")
@export var missile_thingy: AnimatedSprite2D
@export var missile_RELOAD_TIME: float = 2.0
var missile_reload: float = 0

@export_subgroup("Hearts")
@export var heart_container: BoxContainer
@export var heart_template: PackedScene = preload("res://assets/better_heart.tscn")

@export_subgroup("Token")
@export var token_container: BoxContainer
@export var token_temp: PackedScene = preload("res://assets/commemorative_token.tscn")

@export_subgroup("Special")
@export var max_health: Dictionary[String, int]
@export var heart_icon: Dictionary[String, Texture2D]
@export var max_speed: Dictionary[String, float]
@export var camera_zoom: Dictionary[String, float]

# state variables
var is_dead = false
var Form = "Alien"

#Stuff for stored tokens
var Shift_Tokens = []

#Stuff for UI
var Selector_Index = 0

var Is_Overlapping = true
var First_Entry = true

# Amongus
var Vent_Mode = false
var Vents = []
var Vent_Index = 0
var Vent_Max = 0

func _ready() -> void:
	update_token_display()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		interaction_check()
	if Vent_Mode == false:
		if Input.is_action_just_pressed("Shift"):
			use_shift_token(Selector_Index % token_container.get_child_count())
		if Input.is_action_just_pressed("Reset Shift"):
			Form = "Alien"
		for n in 8:
			if Input.is_action_just_pressed("button_"+str(n+1)):
				use_shift_token(n)
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if event.is_released():
					Selector_Index += 1
					Selector_Index %= token_container.get_child_count()
					update_token_display()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if event.is_released():
					Selector_Index -= 1
					if Selector_Index < 0:
						Selector_Index += token_container.get_child_count()
					update_token_display()

func update_velocity(delta: float) -> Vector2:
	var actual_speed: float = max_speed.get(Form, self.speed)
	if Input.is_action_pressed("up"):
		velocity.y +=  -actual_speed * delta
	if Input.is_action_pressed("down"):
		velocity.y +=  actual_speed * delta
	if Input.is_action_pressed("left"):
		velocity.x +=  -actual_speed * delta
	if Input.is_action_pressed("right"):
		velocity.x +=  actual_speed * delta
	velocity -= velocity * delta * friction
	return velocity

func _physics_process(delta: float) -> void:
	check_interactables()
	update_health()
	if Vent_Mode == false:
		visible = true
		update_velocity(delta)
		if Form != "Plant" && Form != "Turret":
			move_and_slide()
		update_animation(velocity)
		turretStuff(delta)
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
	updateCamera(delta)

func get_shift_token(Shift_ID):
	Shift_Tokens.append(Shift_ID)
	update_token_display()

func use_shift_token(Remove_Index):
	var my_token: commemorative_token = token_container.get_child(Remove_Index)
	if my_token and my_token.Shift_ID in Shift_Tokens:
		Shift_Tokens.remove_at(Shift_Tokens.find(my_token.Shift_ID))
		Form = my_token.Shift_ID
		update_token_display()

func update_token_display():
	for my_inventory: commemorative_token in token_container.get_children():
		my_inventory.reset_number()
	for token: String in Shift_Tokens:
		var found: bool = false
		for my_inventory: commemorative_token in token_container.get_children():
			if my_inventory.Shift_ID == token:
				found = true
				my_inventory.incr_number()
		if not found:
			var new_token: commemorative_token = token_temp.instantiate()
			new_token.ID = token_container.get_child_count()
			token_container.add_child(new_token)
			new_token.Shift_ID = token
			new_token.update_texture()
			new_token.incr_number()
	for my_inventory: commemorative_token in token_container.get_children():
		my_inventory.highlight(Selector_Index == my_inventory.ID)

func update_animation(direction: Vector2):
	var static_forms = ["Plant", "Turret"]
	if direction.length() < 1 or Form in static_forms:
		animatedSprite.play(Form+"_default")
		if direction.length() > 1:
			animatedSprite.flip_h = direction.x < 0
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
	var health_counter: int = 0
	if heart_container.get_child_count() < Health:
		for n in Health - heart_container.get_child_count():
			heart_container.add_child(heart_template.instantiate())
	for heart: TextureRect in self.heart_container.get_children():
		heart.visible = (health_counter < min(Health, max_health.get(Form, Health)))
		if heart_icon.has("Default"):
			heart.texture = heart_icon.get(Form, heart_icon.get("Default"))
		else:
			heart_icon.get_or_add("Default", heart.texture)
		health_counter += 1

	#Check for death
	if Health <= 0:
		death()

func damage(damage):
	Health = min(Health, max_health.get(Form, Health)) - damage

func death():
	if is_dead == false:
		is_dead = true
		print("You fucking died")

func updateCamera(delta):
	camera.zoom += (Vector2.ONE * camera_zoom.get(Form, camera_zoom.get("Default", 2)) - camera.zoom) * delta

func turretStuff(delta):
	if Form == "Turret":
		missile_thingy.visible = true
		missile_reload += delta
		missile_thingy.rotation = self.global_position.angle_to_point(get_global_mouse_position())
		if missile_reload < missile_RELOAD_TIME:
			missile_thingy.animation = "empty"
		else:
			if Input.is_action_just_pressed("Interact"):
				missile_thingy.animation = "empty"
				missile_reload = 0
				var newMissile: Node2D = missile_prefab.instantiate()
				self.get_parent().add_child(newMissile)
				newMissile.global_position = missile_thingy.global_position
				newMissile.rotation = missile_thingy.rotation
			else:
				missile_thingy.animation = "load"
	else:
		missile_thingy.visible = false
