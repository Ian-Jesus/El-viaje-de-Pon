extends CharacterBody2D
const bala = preload("uid://pna8uivww3px")
var velocidad = 550

func movimiento():
	var direction := Input.get_axis("izq", "der")
	if direction:
		velocity.x = direction * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
	if Input.is_action_just_pressed("ata"):
		disparo()

func disparo():
	# "Muzzle" is a Marker2D placed at the barrel of the gun.
	var b = bala.instantiate()
	b.iniciar($Marker2D.global_position)
	get_tree().root.add_child(b)

func _physics_process(_delta):
	movimiento()
	move_and_slide()
