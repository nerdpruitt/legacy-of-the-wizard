class_name PlayerBaseMovement
extends Node

@export var actor: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D

@export var speed = 130.0
@export var jump_velocity = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		actor.velocity.y = jump_velocity

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if actor.is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		actor.velocity.x = direction * speed
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed)

	actor.move_and_slide()
