class_name Orb
extends Node2D

@onready var orb_scene = preload("res://player/orb.tscn")

var orbit_distance: float
var orbit_speed: float
var orbit_falloff: Curve
var lifetime: float

var orb: Node2D
var orb_sprite: AnimatedSprite2D
var age: float = 0
var angle: float = 0
var distance: float = 0

func _init(life: float, dist: float, speed : float, falloff: Curve) -> void:
	lifetime = life
	orbit_distance = dist
	orbit_speed = speed
	orbit_falloff = falloff
	distance = lerp(0., orbit_distance, orbit_falloff.sample_baked(0))
	
func _ready() -> void:
	orb = orb_scene.instantiate()
	orb.position.x = distance
	self.add_child(orb)
	orb_sprite = orb.find_child("orb_sprite")
	orb_sprite.play()
	
func _physics_process(delta: float) -> void:
	age += delta
	var falloff: float = orbit_falloff.sample_baked(age/lifetime)
	
	distance = lerp(0., orbit_distance, falloff)
	#print(age, distance)
	
	angle += (orbit_speed - falloff) * delta
	orb.position = Vector2(distance, 0.).rotated(angle / TAU)
	
	if age >= lifetime:
		queue_free()
		
func _process(_delta: float) -> void:
	var offset: Vector2 = Vector2.ZERO
	offset.x = (orb.global_position.x as int - orb.global_position.x)
	offset.y = (orb.global_position.y as int - orb.global_position.y)
	orb_sprite.position = offset
