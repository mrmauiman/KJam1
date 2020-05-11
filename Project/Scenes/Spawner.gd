extends Spatial

export(Array, PackedScene) var spawnables
export(Array, int) var probabilities

var rng = RandomNumberGenerator.new()
var timer = 0.0

const spawn_rate = 0.5
const launch_power = 15

func prob_sum():
	var rv = 0
	for i in probabilities:
		rv += i
	return rv

func get_spawnable(value):
	var rv
	var sum = 0
	for i in range(probabilities.size()):
		sum += probabilities[i]
		if value <= sum:
			rv = spawnables[i]
			break
	return rv

func _ready():
	rng.randomize()

func _process(delta):
	timer += delta
	if timer > spawn_rate:
		timer = 0
		var ran = rng.randi_range(0, prob_sum())
		var spawnable = get_spawnable(ran)
		var y_angle = rng.randi_range(0, 360)
		var x_angle = rng.randi_range(0, 45)
		var launch_vec = Vector3(0, 0, 1)
		launch_vec = launch_vec.rotated(Vector3(1, 0, 0), deg2rad(x_angle))
		launch_vec = launch_vec.rotated(Vector3(0, 1, 0), deg2rad(y_angle))
		var instance = spawnable.instance()
		instance.apply_central_impulse(launch_vec*launch_power)
		add_child(instance)