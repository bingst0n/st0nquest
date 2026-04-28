extends CharacterBody2D

var SPEED: float = 100.0

@onready var sprite = $AnimatedSprite2D
var last_direction = "down"

var normalizer: float = 1.0

func _ready():
	sprite.play("idledown")

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
	

	velocity = Vector2(xvel, yvel) * SPEED * normalizer
	move_and_slide()
	position = position.round()

	if velocity != Vector2.ZERO:
		sprite.play("walk" + last_direction)
	else:
		sprite.play("idle" + last_direction)
