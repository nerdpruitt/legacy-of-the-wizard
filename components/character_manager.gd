# this is just for debugging character behavior
class_name CharacterManager
extends Node

var max_time = 1.0
var time_left = 0.0
var can_change = false

enum {CHAR_1, CHAR_2, CHAR_3}
var state
var character

var lyll = preload("res://actors/player/lyll.tscn")
var xemn = preload("res://actors/player/xemn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = max_time
	state = CHAR_1
	switch_character(xemn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_left > 0.0:
		time_left -= delta
	elif time_left <= 0.0 and can_change == false:
		print("Can now change characters")
		can_change = true
	
	match state:
		CHAR_1:
			if Input.is_action_just_pressed("ui_accept") and can_change == true:
				state = CHAR_2
				print(state)
				print("char 2 active")
				
				switch_character(lyll)

		CHAR_2:
			if Input.is_action_just_pressed("ui_accept") and can_change == true:
				state = CHAR_1
				print(state)
				print("char 1 active")
				
				switch_character(xemn)

		#CHAR_3:
			#if Input.is_action_just_pressed("ui_accept") and can_change == true:
				#state = CHAR_1
				#print(state)
				#print("char 1 active")
				#reset_char_switch_delay()

func switch_character(character_scene):
	if is_instance_valid(character):
		character.queue_free()

	character = character_scene.instantiate()
	self.add_child(character)
	
	reset_char_switch_delay()

func reset_char_switch_delay():
	time_left = max_time
	can_change = false
