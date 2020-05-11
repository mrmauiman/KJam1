extends KinematicBody

var controller = "controller_0" setget set_controller, get_controller
var is_key_board = false setget set_is_key_board, get_is_key_board
var holding = null setget set_holding, get_holding

const gravity = 10
const max_fall_speed = 20
const max_move_speed = 15
const acceleration = 15
const turn_speed = 5 # degrees
const friction = 0.2
const up = Vector3.UP
const shoot_power = 40
const dazed_timer = 3

#enum states {FREE_MOVE, SUCKING, HOLDING}

var speed = 0
var rot = Vector2(1, 0)
var velocity = Vector3.ZERO
var dazed = false
var timer = 0
var score = 0
#var state = states.FREE_MOVE

# helpers
func move_input():
	# input
	var input_vec = Vector2.ZERO
	if is_key_board:
		input_vec = Vector2(Input.is_action_pressed("key_board_up") as int - Input.is_action_pressed("key_board_down") as int, Input.is_action_pressed("key_board_right") as int - Input.is_action_pressed("key_board_left") as int)
	else :
		input_vec = Vector2(Input.get_action_strength(controller + "_up")-Input.get_action_strength(controller + "_down"), Input.get_action_strength(controller + "_right")-Input.get_action_strength(controller + "_left"))
	if input_vec.length() >= 1:
		input_vec = input_vec.normalized()
	return input_vec

# State Functions
func free_move(delta):
	# gravity
	velocity.y = clamp(velocity.y - gravity, -max_fall_speed, 0)
	var input_vec = move_input()
	
	if input_vec.length() > 0:
		var angle = rot.normalized().angle_to(input_vec.normalized())
		if angle >= deg2rad(3):
			rot = rot.rotated(turn_speed*delta)
		elif angle <= deg2rad(-3):
			rot = rot.rotated(-turn_speed*delta)
		rotation = Vector3(0, (deg2rad(360) - rot.angle()) + deg2rad(90), 0)
	
	speed = clamp(speed + (input_vec.length()*acceleration), -max_move_speed, max_move_speed)
	if input_vec.length() == 0:
		speed = lerp(speed, 0, friction)
		if (speed < 0.1):
			speed = 0
	
	rot = rot.normalized()
	velocity.x = rot.x * speed
	velocity.z = rot.y * speed

func sucking(delta):
	if Input.is_action_pressed(controller + "_suck") and holding == null:
		$Suck.visible = true
	else:
		$Suck.visible = false

func holding(delta):
	if Input.is_action_just_pressed(controller + "_push") and holding != null:
		holding.shoot()
		holding = null

func got_hit():
	dazed = true
	score = max(score-500, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	match (state):
#		states.FREE_MOVE:
#			free_move(delta)
#		states.SUCKING:
#			sucking()
#		states.HOLDING:
#			holding()
	if dazed:
		timer+=delta
		if timer > dazed_timer:
			timer = 0
			dazed = false
	else:
		free_move(delta)
		sucking(delta)
		holding(delta)
		move_and_slide(velocity, up)

# Setters and Getters
func set_controller(new_controller):
	controller = new_controller
func get_controller():
	return controller
func set_is_key_board(p_is_key_board):
	is_key_board = p_is_key_board
func get_is_key_board():
	return is_key_board

func set_holding(hold):
	holding = hold
func get_holding():
	return holding
