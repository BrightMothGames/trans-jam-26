extends CharacterBody2D

@export var speed: float = 15.
@export var shot_cooldown: float = .5
@export var orb_lifetime: float = 10.
@export var orb_orbit_distance: float = 20.
@export var orb_orbit_speed: float = 10.
@export var orb_orbit_falloff: Curve


@onready var sprite: AnimatedSprite2D = $animated_sprite_2d
@onready var orb_preload: PackedScene = preload("res://player/orb.tscn")
@onready var shot_cooldown_timer: Timer

var last_move_direction: Vector2 = Vector2.DOWN
var moving: bool = false

func _ready() -> void:
	shot_cooldown_timer =  Timer.new()
	add_child(shot_cooldown_timer)
	shot_cooldown_timer.wait_time = shot_cooldown
	shot_cooldown_timer.one_shot = true

func _physics_process(delta: float) -> void:
	# apply input, scaled by delta and speed
	velocity = InputManager.joyL.normalized() * delta * speed * 150. # magic number to make speed value less extreme
	
	#apply velocity using built in method
	move_and_slide()
	
	if InputManager.action and shot_cooldown_timer.is_stopped():
		shot_cooldown_timer.start()
		_on_fire()
	
func _process(_delta: float) -> void:
	# movement vector snapped to cardinal directions
	if not InputManager.joyL.normalized().snapped(Vector2.ONE).is_zero_approx():
		last_move_direction = InputManager.joyL.normalized().snapped(Vector2.ONE)
	
	# prevent diagonals, always return horizontal movment over vertical movement
	if abs(last_move_direction.x) + abs(last_move_direction.y) == 2:
		last_move_direction = Vector2(last_move_direction.x, last_move_direction.y * 0)
	
	moving = true if velocity.length() > .1 else false
	#print(velocity, last_move_direction, moving)
	
	match last_move_direction:
		Vector2.UP:
			sprite.flip_h = false
			if moving:
				sprite.play("walk_up")
			else:
				sprite.play("idle_up")
		Vector2.RIGHT:
			sprite.flip_h = false
			if moving:
				sprite.play("walk_right")
			else:
				sprite.play("idle_right")
		Vector2.DOWN:
			sprite.flip_h = false
			if moving:
				sprite.play("walk_down")
			else:
				sprite.play("idle_down")
		Vector2.LEFT:
			sprite.flip_h = true
			if moving:
				sprite.play("walk_left")
			else:
				sprite.play("idle_left")
		_: #default action
			pass
	
	# snap sprite to the nearest pixel
	var offset: Vector2 = Vector2.ZERO
	offset.x = (position.x as int - position.x)
	offset.y = (position.y as int - position.y)
	sprite.position = offset

func _on_fire():
	var orb = Orb.new(orb_lifetime,
					orb_orbit_distance,
					orb_orbit_speed,
					orb_orbit_falloff)
	self.add_child(orb)
