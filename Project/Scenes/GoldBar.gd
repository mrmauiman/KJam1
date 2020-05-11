extends RigidBody

var suck_power = 2
var threshold = 1
var attached_to
var attached
var timer = 0
var attack_span = 1.5
var attacking
const shoot_power = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot():
	mode = MODE_RIGID
	attached = false
	attached_to = null
	apply_central_impulse(global_transform.basis.z*shoot_power)
	attacking = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not attached:
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
				vec *= suck_power
				apply_central_impulse(vec)
			else:
				mode = MODE_STATIC
				attached = true
				attached_to = closest
				closest.get_parent().set_holding(self)
	else:
		global_transform.origin = attached_to.global_transform.origin
		global_transform.basis = attached_to.global_transform.basis
		translate(Vector3(0, 0, 1))

func _process(delta):
	if attacking:
		timer += delta
	if timer > attack_span:
		timer = 0
		attacking = false
	


func _on_GoldBar_body_entered(body):
	if body.is_in_group("maid"):
		if attacking:
			body.got_hit()
