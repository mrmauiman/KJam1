extends RigidBody

const speed = 4
const threshold = 1
var velocity = Vector3.ZERO setget set_velocity, get_velocity
var timer = 0
var life_span = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var areas = $Area.get_overlapping_areas()
	var suckies = []
	for i in areas:
		if i.is_in_group("suck_collider") and i.visible:
			suckies.append(i)
	if suckies.size() > 0:
		var closest = suckies[0]
		for i in suckies:
			if i.global_transform.origin - global_transform.origin < closest.global_transform.origin - global_transform.origin:
				closest = i
		
		var diff = closest.global_transform.origin - global_transform.origin
		if diff.length() > threshold:
			var vec = diff.normalized()
			vec *= speed
			apply_central_impulse(vec)
		else:
			closest.get_parent().score += 100
			destroy()

func destroy():
	queue_free()

func _process(delta):
	timer += delta
	if timer > life_span:
		destroy()

# Setters and Getters
func set_velocity(vel):
	velocity = vel
	print(velocity)

func get_velocity():
	return velocity
