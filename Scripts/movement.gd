extends CharacterBody2D

var SPEED: float = 100.0

@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
var last_direction = "down"

@export var cam_limit_left: int   = -10000000
@export var cam_limit_right: int  =  10000000
@export var cam_limit_top: int    = -10000000
@export var cam_limit_bottom: int =  10000000

var normalizer: float = 1.0

const TILE_GRASS = 0
const TILE_WATER = 1
const TILE_SAND  = 2
const TILE_ROCK  = 3
const TILE_TREE  = 4

func _ready():
	add_to_group("players")
	sprite.play("idledown")
	camera.limit_left   = cam_limit_left
	camera.limit_right  = cam_limit_right
	camera.limit_top    = cam_limit_top
	camera.limit_bottom = cam_limit_bottom

const INTERACT_RANGE := 20.0

func _physics_process(_delta):
	var xvel = Input.get_axis("ui_left", "ui_right")
	var yvel = Input.get_axis("ui_up", "ui_down")

	if xvel < 0:
		last_direction = "left"
	if xvel > 0:
		last_direction = "right"
	if yvel > 0:
		last_direction = "down"
	if yvel < 0:
		last_direction = "up"

	if abs(xvel) + abs(yvel) > 1:
		normalizer = 1.0 / sqrt(2)
	else:
		normalizer = 1.0

	if Input.is_action_pressed("run"):
		SPEED = 150.0
	else:
		SPEED = 100.0

	if Input.is_action_just_pressed("interact"):
		if not DialogueManager.is_open:
			var hitbox_center = global_position + Vector2(0, 14)
			for door in get_tree().get_nodes_in_group("doors"):
				if hitbox_center.distance_to(door.global_position) <= INTERACT_RANGE:
					SceneManager.go_to(door.destination)
					return
			for obj in get_tree().get_nodes_in_group("interactables"):
				if hitbox_center.distance_to(obj.global_position) <= INTERACT_RANGE:
					DialogueManager.show_dialogue(
						obj.get("speaker") if obj.get("speaker") != "" else null,
						obj.get("dialogue_text")
					)
					return

	velocity = Vector2(xvel, yvel) * SPEED * normalizer
	move_and_slide()
	camera.offset = Vector2.ZERO
	var center = camera.get_screen_center_position()
	camera.offset = center.round() - center

	if velocity != Vector2.ZERO:
		sprite.play("walk" + last_direction)
	else:
		sprite.play("idle" + last_direction)
