extends CanvasLayer
# Temporizadores
@onready var tiempoJ: Timer = $TiempoJuego
@onready var inicioT: Timer = $InicioTimer
# Etiquetas
@onready var mensaje: Label = $Mensaje
@onready var puntuacion: Label = $Puntuacion
@onready var tiempoE: Label = $Tiempo
#Variables
var vida = 3
var cont = 0
var punt = 0
@export var condicionVictoria = 100
var unicavez:bool=true

func _ready() -> void:
	iniciarTimer()
	Global.enemigo_destruido.connect(Callable(self,"_enemigo_destruido"),10)
	Global.pon_daño.connect(Callable(self,"_pon_recibe_daño"))

func _process(delta: float) -> void:
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

# esta condicion de victoria es por tiempo
func _condicion_victoria_t():
	Global.puntuacion = punt
	Global.victoria.emit()

# esta condicion de victoria es por puntos
func _condicion_victoria_p():
	if punt >= condicionVictoria and unicavez:
		Global.puntuacion = punt
		Global.victoria.emit()
		unicavez = false

func iniciarTimer():
	cont+=1
	mensaje.text = "Nave Preparada!"
	inicioT.start()

func _pon_recibe_daño():
	vida -= 1
	if vida <= 0:
		Global.puntuacion = punt
		Global.derrota.emit()

func _enemigo_destruido(puntos):
	punt+= puntos
	puntuacion.text= str(punt)

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
			mensaje.text = "Motor de propulsión líquida que opera bajo un ciclo generador de gas de alta presión Preparado!"
			inicioT.start()
		5:
			mensaje.text = ""
		6:
			$InicioTimer.stop()


func _on_tiempo_juego_timeout() -> void:
	_condicion_victoria_t()
