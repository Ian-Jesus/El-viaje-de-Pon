extends Node
const max_punt = "user://max_punt.dat"
const max_punt_legacy = "res://max_punt.dat"
signal enemigo_destruido(_puntos:int)
signal pon_daño
signal dañoDrMedusa(vida:int)
signal derrota
signal victoria
signal aumentarDificultad(nivelDificultad:int)
var puntuacion:int = 0
var juego_terminado: bool = false
var datos_max:Dictionary={
	"max":0
}

func _ready() -> void:
	cargar_max_puntuacion()
	enemigo_destruido.connect(Callable(self, "_sumar_puntuacion"))
	derrota.connect(Callable(self,"_derrota"))
	victoria.connect(Callable(self,"_victoria"))

func _sumar_puntuacion(puntos: int) -> void:
	puntuacion += puntos

func _victoria():
	if juego_terminado:
		return
	juego_terminado = true
	guardar_max_puntuacion()
#	get_tree().change_scene_to_file("uid://ckoiffb6wcmpj")
	call_deferred("_cambiar_escena_v")

func _derrota():
	if juego_terminado:
		return
	juego_terminado = true
	guardar_max_puntuacion()
	call_deferred("_cambiar_escena_d")

func _cambiar_escena_v():
	get_tree().change_scene_to_file("uid://b71q1rtiudscd")
	
func _cambiar_escena_d():
	get_tree().change_scene_to_file("uid://b8gi5dfubn3ib")

func guardar_max_puntuacion():
	if puntuacion > datos_max["max"]:
		datos_max["max"] = puntuacion
		var archivo = FileAccess.open(max_punt,FileAccess.WRITE)
		if archivo == null:
			push_error("No se pudo guardar la puntuación máxima: %s" % error_string(FileAccess.get_open_error()))
			return
		archivo.store_var(datos_max)
		archivo = null

func cargar_max_puntuacion():
	var ruta = max_punt if FileAccess.file_exists(max_punt) else max_punt_legacy
	if not FileAccess.file_exists(ruta):
		return
	var archivo = FileAccess.open(ruta,FileAccess.READ)
	if archivo == null:
		push_error("No se pudo cargar la puntuación máxima: %s" % error_string(FileAccess.get_open_error()))
		return
	var datos: Variant = archivo.get_var()
	archivo = null
	if datos is Dictionary and datos.get("max") is int:
		datos_max["max"] = datos["max"]
	else:
		push_error("El archivo de puntuación máxima tiene un formato inválido.")
