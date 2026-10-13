# PonNave
Mini Juego de Pon y Pin: te mueves con una nave de izquierda a derecha disparando a meteoritos y/o enemigos

# Sprites
Como estamos cerca de la etapa final necesitamos sprites para los personajes, por suerte mi mujer es la animadora del corto de pon y pin así que tendremos sus modelos oficiales!!
Necesitamos sprites de:
- Pon volando normal
- Pon atacando (2 sprites)
- Meteorito (2 o 3 sprites)
- Secuaz de Medusa
- El mismisimo Dr Medusa (3 sprites, volando, riendose, atacando)
- Efectos especiales (ataque pon, ataque medusa y ataque secuaz pueden ser el mismo, ataque especial de medusa: golpe adelante y/o barrido)

## Errores actuales
 No hay errores

## Capa y Mascara
####  El * es para decir que hay cambio de estado:
#### - Si esta antes (\*X) todavia no lo activamos y se activa con alguna señal u otro
#### - Si esta despues (X\*) quiere decir que se desactiva luego con alguna señal u otro.
Las áreas son para detectar daño y los personajes en si colisiones sin daño
|Objeto|C1|C2|C3|C4|M1|M2|M3|M4|
|---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|Pon|X||||||X||
|__AreaPon||||||X|||
|Bala|X||||||
|Enemigo1||X|||||X||
|__AreaEnemigo1|||||X|||| 
|Enemigo2||X|||||X||
|__AreaEnemigo2|||||\*X|||X|
|BalaEnemigo2||X|||||||
|Invocador||X|||||X||
|Muros|||X||||||
## Grupos
**jugador:** Pon
**enemigo:** Invocador
**inmune:** AreaInmuneE2


## Siguientes push
- Crear un enemigo3 el cual sera el jefe:
	Pienso en una nave que aparezca unas cuantas veces en el nivel
	demo y ataque en linea recta con un laser y luego desaparezca.
	El enemigo posiblemente sea el ¿doctor medusa? (creo que asi se llamaba haha)
#### Avance:
El enemigo ya esta agregado, el script unicamente controla un timer para cambiar de estados (desde un estado nexo) al Dr Medusa.
Aun no estan programadas las acciones es lo siguiente en la lista.

- Hacer varios niveles para ir introduciendo las mecanicas:
	1. Aprender a destruir meteoritos (mision: destruir x meteoritos) dificultad 0
	2. Encuentro con los primeros OVNIs (mision: destruir x OVNIs) dificultad 0
	3. Practicar la mecanica un poco mas (mision por tiempo) dificultad 1
	(Aparece el Jefe, no peleas con el) 
	4. Pelea con el jefe pero escapa dificultad 2
	5. Pelea con el jefe dificultad 2
#### Avance:
Aun no lo empece

## Informacion Importante (posibles correcciones si estoy motivado)
**El HUD esta manejando logica de juego!!!!**
Eso no deberia ser así, la solución una escena que controle la logica de juego (Controlador)