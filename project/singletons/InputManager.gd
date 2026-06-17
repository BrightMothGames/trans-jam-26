extends Node

var joyLX = 0
var joyLY = 0
#var joyRX = 0
#var joyRY = 0

var joyL = Vector2.ZERO
#var joyR = Vector2.ZERO

var action:bool
var interact:bool

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_window().current_screen = 1
	#get_window().mode = Window.MODE_FULLSCREEN
	pass

signal action_pressed
signal interact_pressed

signal up_pressed
signal down_pressed
signal left_pressed
signal right_pressed

func _input(event) -> void:
	if event.is_action_pressed("LMB") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta) -> void:
	action = Input.is_action_pressed("Action")
	if Input.is_action_just_pressed("Action"):
		action_pressed.emit()
	
	interact = Input.is_action_pressed("Interact")
	if Input.is_action_just_pressed("Interact"):
		interact_pressed.emit()
	
	
	joyLX = Input.get_action_strength("MoveX+") - Input.get_action_strength("MoveX-")
	joyLY = Input.get_action_strength("MoveY+") - Input.get_action_strength("MoveY-")
	if Input.is_action_just_pressed("MoveX+"):
		right_pressed.emit()
	if Input.is_action_just_pressed("MoveX-"):
		left_pressed.emit()
	if Input.is_action_just_pressed("MoveY+"):
		up_pressed.emit()
	if Input.is_action_just_pressed("MoveY-"):
		down_pressed.emit()
	
	#joyRX = Input.get_action_strength("LookX+") - Input.get_action_strength("LookX-")
	#joyRY = Input.get_action_strength("LookY+") - Input.get_action_strength("LookY-")
	
	joyL = Vector2(joyLX,joyLY)
	#joyR = Vector2(joyRX,joyRY)

	if Input.is_action_just_released("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_tree().quit()
