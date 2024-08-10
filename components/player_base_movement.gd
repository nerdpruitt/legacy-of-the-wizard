class_name PlayerBaseMovement
extends Node

enum { MOVE, CLIMB }

@export var actor: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D

@export var speed = 130.0
@export var jump_velocity = -300.0

@onready var ladderCheck = $"../LadderCheck"
var on_ladder = false
var ladder_left = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = MOVE

func is_on_ladder():
	if not ladderCheck.is_colliding(): 
		return false
		
	var collider = ladderCheck.get_collider()
	if not collider.is_in_group("Ladder"): 		
		return false
	
	ladder_left = collider.global_position.x	
	return true
	
func _physics_process(delta):
	on_ladder = is_on_ladder()	
	
	match state:
		MOVE: move_state(delta)
		CLIMB: climb_state(delta)

func move_state(delta):
	if is_on_ladder() and Input.is_action_pressed("move_up"):
		state = CLIMB
	
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
	
func climb_state(delta):
	if not is_on_ladder():
		state = MOVE
		
	# snap character to ladder
	if (ladder_left):
		actor.global_position.x = ladder_left
		ladder_left = null
		
	if Input.is_action_pressed("jump"):
		state = MOVE
		
	if Input.is_action_pressed("move_up"):
		actor.velocity.y = -speed * delta * 10
		animated_sprite.play("climb")
	elif Input.is_action_pressed("move_down"):
		actor.velocity.y = speed * delta * 10
		animated_sprite.play("climb")
	else:
		actor.velocity.y = 0
		animated_sprite.play("climb_idle")
		
	actor.move_and_slide()
