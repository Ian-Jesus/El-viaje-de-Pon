extends CharacterBody2D
# Por algun motivo no vuelve a Nexo, la idea es que se quede ahí hasta el siguiente timeout
# Orden: Nexo -> (se activa timeout) -> Llama a la accion -> Nexo -> (se activa timeout) -> Llama a la accion -> ...


# Idea: puedo hacer ataques predeterminados y de ahi que vaya eligiendo que ataque usar
# Ataque 1) golpe con tentaculo: Dr medusa se muestra por un segundo o dos y luego ataca en esa misma direccion (podria ser fuego tambien del cohete).
# Ataque 2) lluvia de bombas: tira 3 o 4 bombas al mismo tiempo, caen todas a la par dejando un espacio en medio para pasar, se muestra en el medio y rie malevolamente antes de atacar.
# Ataque 3) paraguas escudo: aparece y usa un paraguas para reflejar el ataque de pon, lo transforma en dos ataques.
# Dr Medusa sera implementado como maquina de estados
#region ariables
var tiempoAtaque: float = 11.0
var velocidadBase: float = 333.3
# Puedo ver temas de velocidad para ver que tan aleatorio aparece, o directamente crearlo en una posicion aleatoria.
@onready var timerAtaque: Timer = $dispararT
# Actores guardados
const ADVERTENCIA = preload("uid://dyd2pe77q3m21")
const TENTACULO = preload("uid://c3yapkk2aa71y")

enum estadoM {
	nexo,
	ataque1,
	ataque2,
	ataque3,
	emote,
	derrota, # Ironicamente no es animación de su derrota sino de la señal derrota general, así que aca estara festejando.
	victoria # Y aca estara triste y se estrellará en la tierra.
}
var estadoActual: estadoM = estadoM.nexo
#endregion

#region Basicos

func _ready() -> void:
	Global.derrota.connect(Callable(self,"destruir"))
	Global.victoria.connect(Callable(self,"destruir"))
	# inicia el timer para los ataques y mueve a Dr Medusa
	_iniciar()
func _iniciar():
	velocity = Vector2(velocidadBase,0)
	timerAtaque.wait_time = tiempoAtaque
	timerAtaque.start()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func destruir():
	queue_free()

func volver_nexo():
	estadoActual = estadoM.nexo

func mostrar_estado_actual(ubicacion:String):
	print("ubicacion: ", ubicacion, ", estado Actual: ", estadoActual)
#endregion

#region Estados

func cambiar_actual(): # Elije un estado de forma semialeatoria 
	# puede que no sea la mejor forma pero es de la que mejor entiendo que quiero hacer haha
	# 45% -> Ataque 1
	# 25% -> Ataque 2
	# 25% -> Ataque 3
	# 5% -> Tira emote (aparece, y tira emote, no hace nada más) 
	var prob = randi_range(0,99)
	if prob <= 45:
		estadoActual = estadoM.ataque1
	elif prob > 45 and prob <= 70:
		estadoActual = estadoM.ataque2
	elif prob > 70 and prob <= 95:
		estadoActual = estadoM.ataque3
	elif prob > 95 and prob <= 99:
		estadoActual = estadoM.emote

func cambio_estado() -> void: # Ejecuta las acciones de los distintos estados
	if estadoActual == estadoM.ataque1:
		await ataque1()
		volver_nexo()
	elif estadoActual == estadoM.ataque2:
		await ataque2()
		volver_nexo()
	elif estadoActual == estadoM.ataque3:
		await ataque3()
		volver_nexo()
	elif estadoActual == estadoM.emote:
		await emote()
		volver_nexo()
	elif estadoActual == estadoM.derrota:
		destruir()
	elif estadoActual == estadoM.victoria:
		destruir()

#endregion

#region Ataques

func aparecer():
	velocity = Vector2(0,0)
	velocity = Vector2(0, 200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
func ocultar():
	velocity = Vector2(0,-200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
	velocity = Vector2(velocidadBase,0)

func ataque1():
	await aparecer()
	crear_tentaculo()
	await get_tree().create_timer(4.0).timeout
	await ocultar()

func crear_tentaculo():
	var pos = randi_range(75,700)
	var a = ADVERTENCIA.instantiate()
	a.iniciar(pos)
	get_tree().root.add_child(a)
	await get_tree().create_timer(1.5).timeout
	var t = TENTACULO.instantiate()
	t.iniciar(pos)
	get_tree().root.add_child(t)

func ataque2():
	await aparecer()
	await get_tree().create_timer(4.0).timeout
	await ocultar()
func ataque3():
	await aparecer()
	await get_tree().create_timer(4.0).timeout
	await ocultar()
func emote():
	await aparecer()
	await get_tree().create_timer(4.0).timeout
	await ocultar()
#endregion

#region Otros

func _on_disparar_t_timeout() -> void:
	estadoActual = estadoM.ataque1#cambiar_actual()
	await cambio_estado()
	timerAtaque.wait_time = tiempoAtaque
	timerAtaque.start()

func todo():
	# func aparecer():
	velocity = Vector2(0,0)
	velocity = Vector2(0,200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
	# func esperar():
	await get_tree().create_timer(4.0).timeout
	# func ocultarse():
	velocity = Vector2(0,-200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
	velocity = Vector2(velocidadBase,0)
#endregion
