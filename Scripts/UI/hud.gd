extends CanvasLayer
# Soy un atrevido, como voy a tener logica y controladores de juego en el HUD HAHAHA
# Para esto debo hacer un GameController, chicos no hagan lo que yo hice en casa.
# Para proximos SPRINTS lo corrijo? un like y lo arreglo
# Temporizadores
@onready var tiempoJ: Timer = $TiempoJuego
@onready var inicioT: Timer = $InicioTimer
@onready var peligroT: Timer = $PeligroT
# Etiquetas
@onready var mensaje: Label = $Mensaje
@onready var puntuacion: Label = $Puntuacion
@onready var tiempoE: Label = $Tiempo
#Variables
var segAumentaNivel = [10,20,60,100,120,180]
var nivel = 0
var cont = 0
var punt = 0
@export var vida = 10
var vidaDrMedusa = 10
@export var condicionVictoria = 100
var unicavez:bool=true
var unavez:bool=true
# Otros
@onready var barraVida: TextureRect = $vidaPon
@onready var barraVidaDrMedusa: TextureRect = $vidaDrMedusa

# Preloads
@export var bvp: Array[Resource] = []
@export var bvdm: Array[Resource] = []
func _ready() -> void:
	Global.juego_terminado = false
	Global.puntuacion = 0
	punt = 0
	puntuacion.text = str(punt)
	_iniciarTimer()
	Global.dañoDrMedusa.connect(Callable(self,"_controlador_barra_de_vida_dr_medusa"))
	Global.enemigo_destruido.connect(Callable(self,"_enemigo_destruido"))
	Global.pon_daño.connect(Callable(self,"_pon_recibe_daño"))

func _process(_delta: float) -> void:
	#_condicion_victoria_p()
	_cronometro()

func _cronometro():
	# Calcula el tiempo restante restando el tiempo transcurrido al tiempo total
	var tiempo_restante: float = tiempoJ.wait_time - tiempoJ.time_left
	# Da formato al texto para mostrar minutos y segundos (MM:SS)
	var minutos: int = int(tiempo_restante) / 60
	var segundos: int = int(tiempo_restante) % 60
	# Actualiza el Label usando formato con ceros a la izquierda
	tiempoE.text = "%02d:%02d" % [minutos, segundos]
	if int(tiempo_restante) in segAumentaNivel and unavez:
		nivel+=1
		Global.aumentarDificultad.emit(nivel)
		_mostrar_dificultad_aumentada()
		unavez = false
	elif int(tiempo_restante-5) in segAumentaNivel and not(unavez):
		unavez = true

func _mostrar_dificultad_aumentada():
	mensaje.text='Peligro!!!'
	peligroT.start()
# esta condicion de derrota es por tiempo
func _condicion_derrota_t():
	Global.puntuacion = punt
	Global.derrota.emit()

# esta condicion de victoria es por puntos
func _condicion_victoria_p():
	if punt >= condicionVictoria and unicavez:
		Global.puntuacion = punt
		Global.victoria.emit()
		unicavez = false

func _iniciarTimer():
	cont+=1
	mensaje.text = "Nave Preparada!"
	inicioT.start()

func _pon_recibe_daño():
	vida -= 1
	_controlador_barra_de_vida_pon()
	if vida <= 0:
		Global.puntuacion = punt
		Global.derrota.emit()

func _enemigo_destruido(_puntos:int):
	punt = Global.puntuacion
	puntuacion.text = str(punt)

func _on_inicio_timer_timeout() -> void:
	cont+=1
	match cont:
		1:
			mensaje.text = "Este texto se coló por un agujero de gusano"
			inicioT.start()
		2:
			mensaje.text = "Pon Preparado!"
			inicioT.start()
		3:
			mensaje.text = "Salva al Mundo!"
			inicioT.start()
		5:
			mensaje.text = ""
		6:
			$InicioTimer.stop()

func _controlador_barra_de_vida_pon():
	match vida:
		0:barraVida.texture = bvp[0]
		1:barraVida.texture = bvp[1]
		2:barraVida.texture = bvp[2]
		3:barraVida.texture = bvp[3]
		4:barraVida.texture = bvp[4]
		5:barraVida.texture = bvp[5]
		6:barraVida.texture = bvp[6]
		7:barraVida.texture = bvp[7]
		8:barraVida.texture = bvp[8]
		9:barraVida.texture = bvp[9]

func _controlador_barra_de_vida_dr_medusa(vidaDrMedusa):
	match vidaDrMedusa:
		0:barraVidaDrMedusa.texture = bvdm[0]
		1:barraVidaDrMedusa.texture = bvdm[1]
		2:barraVidaDrMedusa.texture = bvdm[2]
		3:barraVidaDrMedusa.texture = bvdm[3]
		4:barraVidaDrMedusa.texture = bvdm[4]
		5:barraVidaDrMedusa.texture = bvdm[5]
		6:barraVidaDrMedusa.texture = bvdm[6]
		7:barraVidaDrMedusa.texture = bvdm[7]
		8:barraVidaDrMedusa.texture = bvdm[8]
		9:barraVidaDrMedusa.texture = bvdm[9]

func _on_tiempo_juego_timeout() -> void:
	_condicion_derrota_t()

func _on_peligro_t_timeout() -> void:
	mensaje.text=''
	peligroT.stop()
