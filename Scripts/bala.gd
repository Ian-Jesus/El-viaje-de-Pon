extends CharacterBody2D
var velocidad = 750

func iniciar(_position):
	position = _position
	velocity = Vector2(0, -velocidad)

func destruir():
	queue_free()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
