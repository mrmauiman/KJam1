extends KinematicBody

var controller = "controller_0" setget set_controller, get_controller
var is_key_board = false setget set_is_key_board, get_is_key_board
var player = 0

const gravity = 10
const max_fall_speed = 20
const max_move_speed = 15
const acceleration = 15
const turn_speed = 5 # degrees
const friction = 0.5
const up = Vector3.UP

enum states {FREE_MOVE, SUCKING, HOLDING}

var speed = 0
var velocity = Vector3.ZERO
var state = states.FREE_MOVE

# helpers
func move_input():
	# input
	var move_vec = Vector3.ZERO
	if is_key_board:
		move_vec = Vector3(Input.is_action_pressed("key_board_up") as int - Input.is_action_pressed("key_board_down") as int, 0, Input.is_action_pressed("key_board_right") as int - Input.is_action_pressed("key_board_left") as int)
	else :
		move_vec = Vector3(Input.get_action_strength(controller + "_up")-Input.get_action_strength(controller + "_down"), 0, Input.get_action_strength(controller + "_right")-Input.get_action_strength(controller + "_left"))
	if move_vec.length() >= 1:
		move_vec = move_vec.normalized()
	return move_vec

# State Functions
func free_move():
	# gravity
	velocity.y = clamp(velocity.y - gravity, -max_fall_speed, 0)
	var input_vec = move_input()
	
	speed = speed + (max_move_speed * input_vec.length())
	velocity.z = speed
	# rotate(vec3, angle)
	
#	# create acceleration vector
#	move_vec = move_vec * acceleration
#	velocity = velocity + move_vec
#	# friction
#	if move_vec.length() == 0:
#		velocity = lerp(velocity, Vector3(0, velocity.y, 0), friction)
#		if Vector2(velocity.x, velocity.z).length() < 0.1:
#			velocity.x = 0
#			velocity.z = 0
#	# clamp to max speed
#	var clamp_vel = Vector2(velocity.x, velocity.z).clamped(max_move_speed);
#	velocity.x = clamp_vel.x
#	velocity.z = clamp_vel.y

func sucking():
	pass

func holding():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match (state):
		states.FREE_MOVE:
			free_move()
		states.SUCKING:
			sucking()
		states.HOLDING:
			holding()
	move_and_slide(velocity, up)
	print(velocity)

# Setters and Getters
func set_controller(new_controller):
	controller = new_controller
func get_controller():
	return controller
func set_is_key_board(p_is_key_board):
	is_key_board = p_is_key_board
func get_is_key_board():
	return is_key_board
