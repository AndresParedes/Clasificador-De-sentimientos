# Clasificador-De-sentimientos
Proyecto Bi Clasificacion de sentimientos .
* El proyecto consta de 2 directorios compuestos "weka" y "procesamiento de texto".
* En el directorio weka se encuentra implementado un programa en lenguaje java el mismo que para funcionar necesita 2 archivos .arff,
salida y salida1, salida corresponde al dataset de entrenamiento mientras que salida1 corresponde a los datos de test,( la creacion de estos archivos se explicara adelante). Este programa generara un archivo de salida "archivo.arff" donde se encuentra la clasificacion resultante del archivo salida1.
* En el directorio "procesamiento de texto" se encuentran  4 scripts realizados en perl y 7 directorios:class,diccionario,frases,libro,result,tablas,unclass. 
 * En el directorio class se encontrara el archivo salida1.arff el cual sera el resultado final del proyecto, es decir que aqui se encuentra las instancias ya clasificadas
 * En el directorio diccionario se encuentran 4 diccionarios con adjetivos y verbos positivos y negativos respectivamente.
 * En el directorio frases se encontrara el texto separado por oraciones
 * En el directrio libro se encutentran los libros que seran usados como fuente de datos para el procesamiento
 * En el directorio result debera ser ubicado el archivo "archivo.arff" generado por el programa ubicado en el directorio "weka".
 * En el directorio tablas se encontrara el  salida.arff  y salida1.arff los cuales se usan en el programa mencionado anteriormente.
 * En el directorio unclass se neceita ubicar o mover el archivo salida1.arff a este directorio.
* El script 1.frases.pl esta realizado en pearl el cual como argumentos para correr recibira el directorio libro, y el directorio. Este limpiara el texto y luego separara en oraciones y guardara el archivo en el directorio frases.
* El script 2.analisis recibe como argumentos los directorios frases, diccionario y tablas. Este script analizara palabra por palabra el texto ubicado en el directorio frases y generara un archivo con la ponderacion de cada oracion y ademas generara el archivo salida.arff. 
* El script 3.preubas.pl recogera un archivo separado por oraciones y obtendra sus atributos y asi mismo generara el archivo salida1.arff
* El script 4.salida.pl tendra como argumentos el directorio el directorio result unclass y class este unira los resultados obtenidos por el programa en java y los combinara con los atributos generados por el script 3.pruebas.pl y se generara en el directorio class un archivo ya clasificado.
