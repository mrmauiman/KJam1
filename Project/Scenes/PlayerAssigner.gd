extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player1/KinematicBody.set_controller(player_map.player1)
	$Player1/KinematicBody/Icon.texture = load("res://Materials/Textures/PlayerIcons/player1.png")
	$Player2/KinematicBody.set_controller(player_map.player2)
	$Player2/KinematicBody/Icon.texture = load("res://Materials/Textures/PlayerIcons/player2.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
