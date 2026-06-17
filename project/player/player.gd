extends CharacterBody2D

@export var speed: float = 20.
@export var friction: float = 1. 

@onready var sprite: AnimatedSprite2D = $animated_sprite_2d

var last_move_direction: Vector2 = Vector2.DOWN
var moving: bool = false

func _ready() -> void:
	InputManager.connect("left_pressed", _on_left_pressed)
	InputManager.connect("right_pressed", _on_right_pressed)
	InputManager.connect("up_pressed", _on_up_pressed)
	InputManager.connect("down_pressed", _on_down_pressed)

func _physics_process(delta: float) -> void:
	# apply input, scaled by delta and speed
	velocity = InputManager.joyL.normalized() * delta * speed * 150. # magic number to make speed value less extreme
	
	#apply velocity using built in method
	move_and_slide()
	
func _process(_delta: float) -> void:
	# detect if input is being pressed
	moving = true if InputManager.joyL.length() > .1 else false
	
	match last_move_direction:
		Vector2.UP:
			if moving:
				sprite.play("walk_up")
			else:
				sprite.play("idle_up")
		Vector2.RIGHT:
			if moving:
				sprite.play("walk_right")
			else:
				sprite.play("idle_right")
		Vector2.DOWN:
			if moving:
				sprite.play("walk_down")
			else:
				sprite.play("idle_down")
		Vector2.LEFT:
			if moving:
				sprite.play("walk_left")
			else:
				sprite.play("idle_left")
	
	# snap sprite to the nearest pixel
	var offset: Vector2 = Vector2.ZERO
	offset.x = (position.x as int - position.x)
	offset.y = (position.y as int - position.y)
	sprite.position = offset

func _on_left_pressed() -> void:
	last_move_direction = Vector2.LEFT

func _on_right_pressed() -> void:
	last_move_direction = Vector2.RIGHT

func _on_up_pressed() -> void:
	last_move_direction = Vector2.DOWN

func _on_down_pressed() -> void:
	last_move_direction = Vector2.UP
