extends Control

func _ready() -> void:
	Global.cargar_max_puntuacion()

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file( "uid://36p6jvu502qk")

func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("uid://dcigxps7xjncl")

func _on_salir_pressed() -> void:
	get_tree().quit()
	# no se que tan necesario sea pero queda como un ultimo punto de guardado
	Global.guardar_max_puntuacion()
