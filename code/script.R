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
data_csv <- import(file="input/Enero - Cabecera - Caracteristicas generales (Personas).csv")#Importamos las dos bases de datos con el comando import
data_csv2<-import(file ="input/Enero - Cabecera - Ocupados.csv" )
#2.2 Exportar 
export(x=data_csv , file="output/Caracteristicasgenerales(Personas).rds") #Exportamos las dos bases de datos a la carpeta output
export(x=data_csv2 , file="output/Ocupados.rds")

# 3. Generar variables
caracteristicasgenerales <- import("output/Caracteristicasgenerales(Personas).rds") #Abrimos las bases de datos que guardamos en output
ocupados <- import("output/Ocupados.rds")

ocupados$ocupados<-1 #Agregamos una variable  con unos  en la base de datos de ocupados
caracteristicasgenerales <- mutate(caracteristicasgenerales  , joven = ifelse(P6040>=18 &  P6040<=28, yes=1 , no=0)) #Buscando en el directorio de la GIH encontramos que la varialbel P6040 es la variable de años cumplidos. Creamos la condicion que ponga uno si la variable P6040 va de 18 a 28 años y cero si no cumple esa condición

export(x=ocupados , file="output/Ocupadosconvariableocupados.rds") #Exportamos los resultados del punto  tres a la carpeta de output
export(x=caracteristicasgenerales , file="output/caracteristicasgeneralesconvjovenes.rds")



## 4. Eliminar filas/columnas de un conjunto de datos
caracteristicasgenerales <-caracteristicasgenerales %>% subset(P6040>=18 & P6040<=70)
caracteristicasgenerales <-caracteristicasgenerales %>% select(SECUENCIA_P, ORDEN,HOGAR, DIRECTORIO,P6020, P6040, DPTO, fex_c_2011, ESC, MES,P6050) #La variable P6920 no se encuentra en la base de datos de caracterisiticas generales y la variable P6050 no se encuentra en la base de datos ocupados. Por lo tanto agregaremos la variable P6050  de la base de caracteristicas generales y agregaremos en la base de datos de ocupados la variable P6920. 
ocupados <-ocupados %>% select(SECUENCIA_P, ORDEN,HOGAR, DIRECTORIO,ocupados,INGLABO,P6920)

export(x=ocupados , file="output/Ocupadosreducucida.rds")#Exportamos las dos bases de datos resultantes del punto cuatro a la carpeta de output
export(x= caracteristicasgenerales, file="output/caracteristicasgeneralesreducucida.rds")

# 5. Combinar bases de datos 

unionbases= full_join(x=caracteristicasgenerales,y=ocupados,by=c("SECUENCIA_P", "ORDEN","HOGAR", "DIRECTORIO"))

export(x=unionbases , file="output/unionbases.rds")

# 6. Descriptivas de un conjunto de datos

#Tabla1: Descripción general de ingresos,pension, departamento y edad
summary(unionbases[,c("INGLABO", "P6040", "DPTO","P6920")])

#Tabla2:Descripción del promedio y media de ingresos y años de escolaridad según el sexo
unionbases %>%
  select(INGLABO,P6020,ESC)%>%
  group_by(P6020)  %>% 
  summarise(promedio_inglabo = mean(INGLABO, na.rm = T),
            media_inglabo = median(INGLABO, na.rm = T),
            promedio_ESC = mean(ESC, na.rm = T),
            media_ESC = median(ESC, na.rm = T))

 

#Tabla3:Descripción de promedio y media de ingreso de los ocupados y la edad promedio y media  de los que estan ocupados y los que no

unionbases %>%
  select(INGLABO,ocupados,P6040)%>%
  group_by(ocupados)  %>% 
  summarise(promedio_inglabo = mean(INGLABO, na.rm = T),
            media_inglabo = median(INGLABO, na.rm = T),
            promedio_P6040 = mean(P6040, na.rm = T),
            media_ESC = median(P6040, na.rm = T))

#Grafico1: Los ingresos promedios según su relación con el jefe de hogar
graph_1 <-unionbases %>% 
  group_by(P6050) %>% 
  summarise(ingresos = mean(INGLABO, na.rm = T)) %>%

  ggplot(data=. , mapping = aes(x = as.factor(P6050) , y = ingresos, fill = as.factor(P6050))) + 
  geom_bar(stat = "identity") 
graph_1

jpeg("output/graph1.jpeg", quality = 75) #Exportamos los gráficos jpeg con la función jpeg() según https://r-coder.com/exportar-graficos-r/

#Grafico2: Los ingresos según la edad
graph_2 <- ggplot(data = unionbases, 
                  mapping = aes( x =P6040 , y = INGLABO, group= as.character(P6040), color = as.factor(P6040))) +
  geom_point(size = 0.5)
graph_2
jpeg("output/graph2.jpeg", quality = 75)
  
#Grafico3: La densidad de los ingresos segun el grado de escolaridad
graph_3 <- filter(unionbases, !is.na(ESC) & INGLABO < 1e+07 ) %>% 
  ggplot(data=. , mapping = aes(x = INGLABO, group = as.factor(ESC), fill = as.factor(ESC))) + 
  geom_density() 

graph_3
jpeg("output/graph3.jpeg", quality = 75)


