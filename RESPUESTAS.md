**PREGUNTA**

1\. ¿Qué pasó en el paso 3 y por qué? Ojo: el valor sí se guardó en disco. ¿Qué es

exactamente lo que quedó desactualizado? Y para que el contador viajara entre las dos

pantallas, ¿cuántos lugares del código tuvieron que ponerse de acuerdo?



Al darle al botón de atrás de android volví a la pantalla visor, pero el contador seguía estando en el mismo número que yo puse en la pantalla control. 



Lo que debería haber quedado desactualizado es el valor del contador en la pantalla visor ya que al darle al botón de atrás de Android se rompe lo que causa que se desincronice el estado de la pantalla mostrando el valor anterior y no el actualizado, aunque data si tiene el valor real



Para que el contador viajara entre las 2 pantallas tuvieron que ponerse de acuerdo 5 lugares de código: 

1\. Pantallavisor: tuvo que empaquetar el valor de valorInicial: \_contador

2\. PantallaControl: recibió el valor de valorInicial

3\. PantallaControl específicamente en la parte de initState porque tuvo que copiar el valorInicial a una variable que fuera local

4\. La salida de PantallaControl tuvo que pasar el valor actualizado y teniendo en cuenta que se usó un PopScope para que al darle al botón de atrás de Android no se perdiera información

5\. PantallaVisor cuando recibe la información.





**PREGUNTA** 

2\. ¿Por qué ahora el botón atrás del sistema no rompe nada? ¿Dónde vive el contador?

En la versión con setState todo dependía del flujo de navegación, y al usar el botón de atrás no se devolvían datos así que la pantalla visor se desfasaba con el valor que poníamos en control



Usando riverpod se desacoplan ambas cosas así que cada vez que haya un cambio del contador se modifica inmediatamente después de hacerlo



¿Dónde vive el contador?

En la memoria, este está fuera del árbol de widgets. Está en state de contadorNotifier por lo que no está limitado a ninguna pantalla





**PREGUNTA**

3\. ¿Qué te permite ver el BlocObserver que las otras dos versiones no te daban?



Me permite ver el historial de cada transición y cual cubit la provocó

Comparado con setState donde los cambios eran locales y privados de cada widget por eso se tenia que poner print en cada pantalla para saber que fue lo que cambió



Comparado con Riverpod en donde los cambios pasaban en la memoria lo que nos ayudaba a saber qué componente fue el que cambió y cuál erra su valor



¿En qué situación real sería útil ese registro?

En el rastreo de errores en la producción cuando la app se cierra inesperadamente 



**PREGUNTA**

4\. Pega la salida de los tres comandos en RESPUESTAS.md. ¿Qué demuestra que los dos

primeros salgan vacíos y el tercero no?



PS C:\\Proyectos flutter\\deber1-estado-streams\\parte\_a\_contador> git diff version/setstate version/riverpod -- lib/domain lib/data



PS C:\\Proyectos flutter\\deber1-estado-streams\\parte\_a\_contador> git diff version/setstate version/bloc     -- lib/domain lib/data



PS C:\\Proyectos flutter\\deber1-estado-streams\\parte\_a\_contador> git diff version/setstate version/bloc --stat -- lib/presentation



&#x20;lib/presentation/estado/contador\_cubit.dart      |  35 ++++++

&#x20;lib/presentation/pantallas/pantalla\_control.dart | 136 +++++++----------------

&#x20;lib/presentation/pantallas/pantalla\_visor.dart   |  79 ++++---------

&#x20;3 files changed, 96 insertions(+), 154 deletions(-)



que los primeros 2 salgan vacíos demuestra que los repositorios y los casos de uso son independientes del gestor de estado y no importa cual de las 3 versiones se usó, estas no cambian ni una línea



que último haya mostrado cambios significa que el gestor de estado está confinado a la capa de presentación



Si mañana tuvieras que cambiar Riverpod por otro

paquete, ¿qué parte del proyecto tendrías que volver a escribir?

Sólo habría que reescribir lib/presentation/ 

y el main.dart 



||setState|Riverpod|Cubit|
|-|-|-|-|
|¿Dónde vive el contador?|En el state de cada widget|en el ContadorNotifier|en el ContadorCubit|
|¿Las pantallas se pasan datos?|Sí|No|No|
|Archivos de presentation/ que tocaste|pantalla\_visor.dart<br />pantalla\_control.dart|contador\_provider<br />pantalla\_visor.dart<br />pantalla\_control.dart|contador\_cubit.dart<br />pantalla\_visor.dart<br />pantalla\_control.dart|
|¿Qué pasa con el botón atrás?|Hace que se desincronice el valor |No se rompe nada|No se rompe nada|
|¿Tuviste que tocar domain/?|No|No|No|





**PREGUNTA** 

5\. Si la app tuviera una sola pantalla, ¿cuál de las tres elegirías y por qué?

¿Y si tuviera ocho pantallas que comparten cinco datos distintos? setState no es “malo”:

cierra tu respuesta diciendo en dos líneas cuándo sí es la opción correcta.



Si tuviera solo una pantalla eligiría setState ya que este no necesita dependencias externas

Si tuviera ocho pantallas usaría Riverpod porque centralizan el estado fuera del árbol de widgets 



setState es muy útil para el estado efímero que no se guarda y es solo visual de un widget. Como por ejemplo alterar la visibilidad de una contraseña





**PREGUNTA**

6\. ¿Por qué la pantalla siguió mostrando “Wi-Fi” si el Wi-Fi ya estaba apagado?

Porque al usar el Future es como si tomaramos una foto en el momento en el que se le ejecuta



¿La app tenía un dato incorrecto, o tenía un dato correcto de un momento

equivocado?

Tenía un dato correcto de un momento equivocado, porque al momento de consultar el dispositivo estaba conectado al Wi-Fi y nos retorna los datos de ese momento.



Después de que el Future tomara la foto y le quitamos la conexión al teléfono este no tenía como reflejarlo en tiempo real.



**PREGUNTA**

7\. ¿Qué pasaría si borras el cancel() del close() del Cubit y el usuario entra y

sale de esa pantalla cincuenta veces?



Ocurre una fuga de memoria ya que al salir sin cancelar se sigue manteniendo una referencia en la memoria de cada una de las veces que se entra en la pantalla



**PREGUNTA**

8\. Con lo que viste: ¿por qué decimos que un Future es una foto y un Stream una

película? Explícalo con la conexión, no con la definición del libro. Cierra nombrando

dos datos de una app real que pedirías con Future y dos que observarías con

Stream.



Future: Cuando se oprime el botón en la primera pantalla, la app captura el estado en ese momento en el que se oprime el botón. No le importa lo que pase después de haber oprimido el botón, la foto ya está tomada.



Stream: En la segunda pantalla no se necesita oprimir ningún botón ya que la app mantiene el lente abierto, como si estuviera grabando un video. Por eso al momento de apagar el Wi-Fi del teléfono cambia al estado "Sin conexión" o en su defecto si solo dejamos los datos móviles encendidos saldrá "Datos móviles".







