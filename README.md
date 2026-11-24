# El viaje de Pon
Mini Juego de Pon y Pin: te mueves con una nave de izquierda a derecha disparando a meteoritos y/o enemigos

# Pon y Pin
Son personajes de un [proyecto de tesis](https://proyectodetesis2026.blogspot.com/?m=1), en busqueda de inspiración para hacer minijuegos en 2D solicite permiso a una de las participantes de la tesis para usar sus personajes en el juego, como esto es un proyecto GNU-v3 quiero aclarar que lo 

# Sprites
Como estamos cerca de la etapa final necesitamos sprites para los personajes, por suerte mi mujer es la animadora del corto de pon y pin así que tendremos sus modelos oficiales!!
Inicialmente tendremos bocetos mios, para recordar los que tengo los marcaré "*(x)*" 
Necesitamos sprites de:
- Pon
	- normal *(x)*
	- atancando
	- dañado
- Meteorito (2 o 3 sprites) *(x)* <-- solo uno
- Secuaz de Medusa
	- normal *(x)*
	- atacando *(x)* (2 sprites)
	- dañado *(x)*
	- invulnerable *(x)*
- Dr Medusa
	- normal *(x)*
	- atancando *(x)*
	- dañado *(x)*
	- riendose *(x)*
	- emote *(x)*

- Efectos especiales
	- ataque pon *(x)*
	- ataque secuaz *(x)*
	- ataques medusa *(x)* <-- solo ataque tentaculo


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
|BalaEnemigo2||X|||||X||
|Invocador||X|||||X||
|Muros|||X||||||
|DrMedusa||X|||||X||
|Tentaculo||X|||||||
|Bomba||X|||X||||
|__AreaBomba|||||X||||
|__Paraguas|||||X||||
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
	- Dr Medusa ya creado*
	- Dr Medusa tiene un único ataque por ahora (golpe de tentaculo)

- Hacer varios niveles para ir introduciendo las mecanicas:
	1. Aprender a destruir meteoritos (mision: destruir x meteoritos) dificultad 0
	2. Encuentro con los primeros OVNIs (mision: destruir x OVNIs) dificultad 0
	3. Practicar la mecanica un poco mas (mision por tiempo) dificultad 1
	(Aparece el Jefe, no peleas con el) 
	4. Pelea con el jefe pero escapa dificultad 2
	5. Pelea con el jefe dificultad 2
- Hacer un solo nivel de 2 o 3 minutos mejor
#### Avance:
Aun no lo empece
- Tengo que hacer que los personajes (pon y sus enemigos) tengan un pequeño tiempo de invencibilidad, para no oneshotear enemigos ni tampoco ser oneshoteado.
#### Avance:
Aun no lo empece

## Informacion Importante (posibles correcciones si estoy motivado)
**El HUD esta manejando logica de juego!!!!**
Eso no deberia ser así, la solución una escena que controle la logica de juego (Controlador)
