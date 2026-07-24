extends CharacterBody2D
var velocidad = 300

func iniciar(_position,_rotation):
	position = _position
	rotation = _rotation
	velocity = Vector2(0, -velocidad).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()


func _on_area_deteccion_body_entered(body: Node2D) -> void:
	body.queue_free()
	queue_free()
	
