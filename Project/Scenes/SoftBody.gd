extends KinematicBody

const speed = 10
var velocity = Vector3.ZERO

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
		
		var vec = (closest.global_transform.origin - global_transform.origin).normalized()
		vec *= speed
		velocity = vec
	else:
		velocity = Vector3.UP*-10
	
	move_and_slide(velocity, Vector3.UP)
