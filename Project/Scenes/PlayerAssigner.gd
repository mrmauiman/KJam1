extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player1/KinematicBody.set_controller(player_map.player1)
	$Player2/KinematicBody.set_controller(player_map.player2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
