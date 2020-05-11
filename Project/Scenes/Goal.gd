extends Spatial



func _on_GoalCollider_body_entered(body):
	if body.is_in_group("maid"):
		if body.holding != null:
			body.score += 1000
			body.holding.queue_free()
			body.holding = null
