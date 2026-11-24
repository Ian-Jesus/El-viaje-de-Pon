extends CharacterBody2D
const bala = preload("uid://pna8uivww3px")
var velocidad = 550
var puede_disparar: bool = true

func movimiento():
	var direction := Input.get_axis("izq", "der")
	if direction:
		velocity.x = direction * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
	if Input.is_action_pressed("ata") and puede_disparar:
		disparo()
		

func disparo():
	# "Muzzle" is a Marker2D placed at the barrel of the gun.
	var b = bala.instantiate()
	b.iniciar($Marker2D.global_position)
	get_tree().root.add_child(b)
	puede_disparar = false
	await get_tree().create_timer(0.75).timeout
	puede_disparar = true

func _physics_process(_delta):
	movimiento()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.pon_daño.emit()
	if body.is_in_group("enemigo2"):
		return
	if body.has_method("destruir"):
		body.destruir()
