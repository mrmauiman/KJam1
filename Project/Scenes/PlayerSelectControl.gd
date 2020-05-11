extends HBoxContainer

enum players {NONE, CPU, KEYBOARD, CONTROLLER1, CONTROLLER2}
const controller_icons_path = "res://Materials/Textures/ControllerIcons/"
const controller_icons = {"none": "", "cpu": controller_icons_path + "cpu.png", "keyboard": controller_icons_path + "keyboard.png", "ps4": controller_icons_path + "ps4.png", "switch": controller_icons_path + "switch.png", "xbox": controller_icons_path + "xbox.png"}
const ready_icons_path = "res://Materials/Textures/ReadyIcons/"
const ready_icons = {"ready": ready_icons_path + "ready.png", "keyboard": ready_icons_path + "keyboard.png", "ps4": ready_icons_path + "ps4.png", "switch": ready_icons_path + "switch.png", "xbox": ready_icons_path + "xbox.png"}
const start_icons_path = "res://Materials/Textures/StartIcons/"
const start_icons = {"keyboard": start_icons_path + "keyboard.png", "ps4": start_icons_path + "ps4.png", "switch": start_icons_path + "switch.png", "xbox": start_icons_path + "xbox.png"}
var player1 = players.NONE
var player2 = players.NONE
var player1_controller
var player2_controller
var player1_ready
var player2_ready
var player1_is_ready = false
var player2_is_ready = false
var devices = {}
var start
var controller_types = {players.NONE: "none", players.CPU: "cpu", players.KEYBOARD: "keyboard", players.CONTROLLER1: "none", players.CONTROLLER2: "none"}

func set_player_1(controller):
	var was = player1
	player1 = controller
	player1_controller.texture = load(controller_icons[controller_types[player1]])
	if player1 == players.NONE:
		devices[was].texture = load(controller_icons[controller_types[was]])
		player1_ready.texture = load("")
		player1_is_ready = false
	else:
		devices[player1].texture = load("")
		player1_ready.texture = load(ready_icons[controller_types[player1]])
		

func set_player_2(controller):
	var was = player2
	player2 = controller
	player2_controller.texture = load(controller_icons[controller_types[player2]])
	if player2 == players.NONE:
		devices[was].texture = load(controller_icons[controller_types[was]])
		player2_ready.texture = load("")
		player2_is_ready = false
	else:
		devices[player2].texture = load("")
		player2_ready.texture = load(ready_icons[controller_types[player2]])

func ready_player_1():
	player1_ready.texture = load(ready_icons["ready"])
	player1_is_ready = true
	start.texture = load(start_icons[controller_types[player1]])

func ready_player_2():
	player2_ready.texture = load(ready_icons["ready"])
	player2_is_ready = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player1_controller = $"Player 1/PlayerBox/Boxes/Controller/ControllerIcon"
	player2_controller = $"Player 2/PlayerBox/Boxes/Controller/ControllerIcon"
	player1_ready = $"Player 1/PlayerBox/Boxes/Ready/ReadyIcon"
	player2_ready = $"Player 2/PlayerBox/Boxes/Ready/ReadyIcon"
	devices[players.KEYBOARD] = $Controllers/ControllerList/Boxes/Keyboard
	devices[players.CONTROLLER1] = $Controllers/ControllerList/Boxes/Controller1
	devices[players.CONTROLLER2] = $Controllers/ControllerList/Boxes/Controller2
	start = $"../StartContainer/Start"
	var c1_name = Input.get_joy_name(0)
	if c1_name == "":
		controller_types[players.CONTROLLER1] = "none"
	elif c1_name == "Sony DualShock 4":
		controller_types[players.CONTROLLER1] = "ps4"
	elif c1_name == "Wireless Gamepad":
		controller_types[players.CONTROLLER1] = "switch"
	else:
		controller_types[players.CONTROLLER1] = "xbox"
	var c2_name = Input.get_joy_name(1)
	if c2_name == "":
		controller_types[players.CONTROLLER2] = "none"
	elif c2_name == "Sony DualShock 4":
		controller_types[players.CONTROLLER2] = "ps4"
	elif c2_name == "Wireless Gamepad":
		controller_types[players.CONTROLLER2] = "switch"
	else:
		controller_types[players.CONTROLLER2] = "xbox"
	devices[players.KEYBOARD].texture = load(controller_icons["keyboard"])
	devices[players.CONTROLLER1].texture = load(controller_icons[controller_types[players.CONTROLLER1]])
	devices[players.CONTROLLER2].texture = load(controller_icons[controller_types[players.CONTROLLER2]])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# keyboard
	if Input.is_action_just_pressed("key_board_left"):
		if player2 == players.KEYBOARD:
			set_player_2(players.NONE)
		elif player1 == players.NONE:
			set_player_1(players.KEYBOARD)
	elif Input.is_action_just_pressed("key_board_right"):
		if player1 == players.KEYBOARD:
			set_player_1(players.NONE)
		elif player2 == players.NONE:
			set_player_2(players.KEYBOARD)
	elif Input.is_action_just_pressed("key_board_ready"):
		if player1 == players.KEYBOARD:
			ready_player_1()
		elif player2 == players.KEYBOARD:
			ready_player_2()
	
	# controller 1
	if Input.is_action_just_pressed("controller_0_left"):
		if player2 == players.CONTROLLER1:
			set_player_2(players.NONE)
		elif player1 == players.NONE:
			set_player_1(players.CONTROLLER1)
	elif Input.is_action_just_pressed("controller_0_right"):
		if player1 == players.CONTROLLER1:
			set_player_1(players.NONE)
		elif player2 == players.NONE:
			set_player_2(players.CONTROLLER1)
	elif Input.is_action_just_pressed("controller_0_ready"):
		if player1 == players.CONTROLLER1:
			ready_player_1()
		elif player2 == players.CONTROLLER1:
			ready_player_2()
	
	# controller 2
	if Input.is_action_just_pressed("controller_1_left"):
		if player2 == players.CONTROLLER2:
			set_player_2(players.NONE)
		elif player1 == players.NONE:
			set_player_1(players.CONTROLLER2)
	elif Input.is_action_just_pressed("controller_1_right"):
		if player1 == players.CONTROLLER2:
			set_player_1(players.NONE)
		elif player2 == players.NONE:
			set_player_2(players.CONTROLLER2)
	elif Input.is_action_just_pressed("controller_1_ready"):
		if player1 == players.CONTROLLER2:
			ready_player_1()
		elif player2 == players.CONTROLLER2:
			ready_player_2()
	
	start.visible = player1_is_ready and player2_is_ready
	if Input.is_action_just_pressed("start"):
		if player1_is_ready and player2_is_ready:
			# player 1
			if player1 == players.KEYBOARD:
				player_map.player1 = "key_board"
			elif player1 == players.CONTROLLER1:
				player_map.player1 = "controller_0"
			elif player1 == players.CONTROLLER2:
				player_map.player1 = "controller_1"
			# player 2
			if player2 == players.KEYBOARD:
				player_map.player2 = "key_board"
			elif player2 == players.CONTROLLER1:
				player_map.player2 = "controller_0"
			elif player2 == players.CONTROLLER2:
				player_map.player2 = "controller_1"
			get_tree().change_scene("res://Scenes/GameWorld.tscn")
