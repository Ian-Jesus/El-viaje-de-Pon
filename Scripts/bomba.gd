extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var aSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var alcance: CollisionShape2D = $CollisionShape2D
# Alcance total = 120
enum estado { CAYENDO, APUNTO, EXPLOTA}
var estado_actual:estado = estado.CAYENDO
var velocidad:float = 300.0
var explota = false
var oneshot = false
# Constantes
const Y_CAMBIO_BOMBA:float = 580.0
const Y_PON:float = 700.0

func iniciar(pos):
	position = pos

func destruir():
	queue_free()

func _ready() -> void:
	Global.derrota.connect(Callable(self,"destruir"))

func _physics_process(delta):
	match estado_actual:
		estado.CAYENDO:
			_iniciar_cayendo()
			_esperando_cambio_apunto()
		estado.APUNTO:
			_iniciar_apunto()
			_esperando_cambio_explota()
		estado.EXPLOTA:
			_iniciar_explota()
	move_and_slide()

func _iniciar_cayendo():
	aSprite.visible = true
	sprite.visible = false
	aSprite.play("quieto")
	alcance.shape.radius = 43.0
	velocity = Vector2(0,velocidad)

func _esperando_cambio_apunto():
	if global_position.y >= Y_CAMBIO_BOMBA or explota:
		estado_actual = estado.APUNTO

func _iniciar_apunto():
	velocity = Vector2(0,velocidad/2)
	aSprite.play("apunto")

func _esperando_cambio_explota():
	if global_position.y >= Y_PON or explota:
		estado_actual = estado.EXPLOTA

func _iniciar_explota():
	velocity = Vector2(0,0)
	aSprite.visible = false
	sprite.visible = true
	alcance.shape.radius = 120.0
	await get_tree().create_timer(0.8).timeout
	destruir()


func _on_area_bomba_body_entered(body: Node2D) -> void:
	if body.has_method("destruir") and not(oneshot):
		body.destruir()
		Global.enemigo_destruido.emit(30)
		oneshot = true
		if body.has_method("destruir") and oneshot:
			body.destruir()

	explota = true
	await _iniciar_explota()
