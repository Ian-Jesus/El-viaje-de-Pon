extends CharacterBody2D
const enemigo = preload("uid://yyuxqkxovco7")
const enemigo2 = preload("uid://cpox8dn7qf13c")

@onready var demorai: Timer = $demoraInvocacion
var nivel = 0

func _ready() -> void:
	Global.aumentarDificultad.connect(Callable(self,"aumentaVelocidad"),nivel)
	velocity = Vector2(200,0)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func invocarEnemigo1(_direccion_aleatoria):
	var e = enemigo.instantiate()
	e.iniciar(position,_direccion_aleatoria)
	get_tree().root.add_child(e)
func invocarEnemigo2(_nivel):
	var e2 = enemigo2.instantiate()
	e2.iniciar(position)
	get_tree().root.add_child(e2)
func aumentaVelocidad(_nivel):
	invocarEnemigo2(_nivel)
	demorai.set_wait_time(funx(_nivel))
#	print('nivel: ',_nivel, '	velocidad: ',funx(_nivel))
# Niveles de dificultad
# Nivel 0 = 3 seg
# Nivel 1 = 2.6 seg
# Nivel 2 = 2.3 seg
# Nivel 3 = 2 seg
# Nivel 4 = 1.8 seg
# Hice mas niveles hasta el 15
# pero por la precision del calculo (15 decimales despues de la coma) no llega hasta mas que en nivel 9 los demas 
func funx(x:int):
# aca estoy creando una funcion con los niveles de dificultad anteriores muy contento de por fin
# poder usar conocimientos de Analisis Matematico de buena manera
	return 0.000000000128166*x**15 - 0.00000001429599*x**14 + 0.000000722539206*x**13 - 0.000021889384086*x**12 + 0.000443080997363*x**11 - 0.006322701949221*x**10 + 0.065393003021682*x**9 - 0.496192656335296*x**8 + 2.764011909967172*x**7 - 11.192442671590223*x**6 + 32.24278618387352*x**5 - 63.6394940659905*x**4 + 80.68966946177709*x**3 - 58.19052600045449*x**2 + 17.362695637695612*x + 3
# (x**3*(1/60)-x**2*(0.1)-x*(7/60)+2.8)


func _on_demora_invocacion_timeout() -> void:
	var direccion_aleatoria = randf_range((PI/2)+0.5,(PI*3/2)-0.5)
	invocarEnemigo1(direccion_aleatoria)
	demorai.start()


func _on_inv_timeout() -> void:
	demorai.start()
