##################################Angela Segura Cod. 201619956   R version 4.1.3 ############################################

###Crear directorio de trabajo##
dir.create("code") #Creamos carpeta llamada code, donde guardaremos el script#
dir.create("output") #Creamos la carpeta output para los datos procesados
list.files() ## Revisamos con que carpetas estamos trabajando#
##El script lo guardamos manualmente en la carpeta de code##

###Instalar librerias##
require(pacman) 
p_load(tidyverse, rio) # Llamamos las librerias  necesarias para el taller##


##TALLER A##

##1.Vectores##

vector1 <- c( 1:100) ##Creamos un vector que tiene los numeros del 1 al 100##
vector2<- seq(1,99, by=2) ##Creamos un vector que tiene los numeros impares del 1 al 99.
vector3<- vector1[-vector2]##Creamos un vector que tiene los numeros. Se realizo mediante la eleminacion de los los elementos del vector1 que estuvieran en el vector2. 

##2. Importar/exportar bases de datos##
#2.1 Importar
data_csv = import(file="input/Enero - Cabecera - Caracteristicas generales (Personas).csv")
data_csv2= import(file ="input/Enero - Cabecera - Ocupados.csv" )
#2.2 Exportar 
export(x=data_csv , file="output/Característicasgenerales(Personas).rds")
export(x=data_csv2 , file="output/Ocupados.rds")




