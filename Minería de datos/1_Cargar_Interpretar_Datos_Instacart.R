# Libraries
library("RMariaDB")
# ---------------------------------------
# Proporciona la infraestructura para representar, manipular y analizar 
# patrones y datos de transacciones (conjuntos de elementos frecuentes 
# y reglas de asociaci?n). 
# ---------------------------------------
#install and load package arules
#install.packages("arules")
library(arules)

# ---------------------------------------
# Extiende las 'arules' del paquete con varias t?cnicas de visualizaci?n 
# para reglas de asociaci?n y conjuntos de elementos. El paquete tambi?n 
# incluye varias visualizaciones interactivas para la exploraci?n de reglas.
# ---------------------------------------
#install and load arulesViz
#install.packages("arulesViz")
library(arulesViz)

# ---------------------------------------
# El tidyverse es una colecci?n obstinada de paquetes R dise?ados para la 
# ciencia de datos
# ---------------------------------------
#install and load tidyverse
#install.packages("tidyverse")
library(tidyverse)

# ---------------------------------------
# Leer archivos de Excel en R
# ---------------------------------------
#install and load readxml
#install.packages("readxml")
library(readxl)

# ---------------------------------------
# Generaci?n de informes din?micos en R
# ---------------------------------------
#install and load knitr
#install.packages("knitr")
library(knitr)

# ---------------------------------------
# Crea gr?ficos y tablas
# ---------------------------------------
#load ggplot2 as it comes in tidyverse
library(ggplot2)

# ---------------------------------------
# Lubridate es un paquete de R que facilita el trabajo con fechas y horas.
# ---------------------------------------
#install and load lubridate
#install.packages("lubridate")
library(lubridate)

# ---------------------------------------
# Herramientas para dividir, aplicar y combinar datos
# ---------------------------------------
#install and load plyr
#install.packages("plyr")
library(plyr)

# ---------------------------------------
# dplyr es una gram?tica de manipulaci?n de datos que proporciona un conjunto 
# consistente de verbos que lo ayudan a resolver los desaf?os m?s comunes de 
# manipulaci?n de datos:
# ---------------------------------------
#install and load dplyr
#install.packages("dplyr")
library(dplyr)

# ---------------------------------------
# est? dise?ado para proporcionar estad?sticas resumidas sobre variables.
# ---------------------------------------
#install and load skimr
#install.packages("skimr")
library(skimr)

# ---------------------------------------
#  Este paquete ofrece una gran flexibilidad para dibujar mapas de ?rbol.
# ---------------------------------------
#install and load treemap
#install.packages("treemap")
library(treemap)

# ---------------------------------------
# Agregaci?n r?pida de datos grandes (por ejemplo, 100 GB en RAM), combinaciones 
# ordenadas r?pidamente, agregar / modificar / eliminar r?pidamente columnas por 
# grupo sin copias, listar columnas, lectura / escritura amigable y r?pida de 
# valores separados por caracteres. Ofrece una sintaxis natural y flexible, para 
# un desarrollo m?s r?pido.
# ---------------------------------------
#install and load data.table
#install.packages("data.table")
library(data.table)

# ---------------------------------------
# Proporciona una infraestructura de investigaci?n para probar y desarrollar 
# algoritmos de recomendaci?n
# ---------------------------------------
#install and load recommenderlab
#install.packages("recommenderlab")
library(recommenderlab)

# ---------------------------------------
# Una rica jerarqu?a de clases de matrices, incluidas matrices triangulares, 
# sim?tricas y diagonales, tanto densas como dispersas y con patrones, entradas 
# l?gicas y num?ricas. Numerosos m?todos y operaciones sobre estas matrices, 
# utilizando bibliotecas 'LAPACK' y 'SuiteSparse'.
# ---------------------------------------
#install and load Matrix
#install.packages("Matrix")
library(Matrix)

#load RMariaDB to connect MySQL
#install.packages("RMariaDB")
library("RMariaDB")

library(tictoc)

#load RMariaDB to connect MySQL
#install.packages("RMariaDB")
# library("RMariaDB")

# Conexión a la base de datos
db <- dbConnect(RMariaDB::MariaDB(), 
                host = "127.0.0.1", 
                user = "root", 
                password = "Parago21", 
                dbname = "Instacart")

# Se cargan el número de departamentos y se mira cuantos hay
instacart_department <- dbGetQuery(db, "SELECT * FROM DEPARTMENT;")
nrow(instacart_department)
## [1] 21

# Se cargan el número de pasillos y se mira cuantos hay
instacart_aisle <- dbGetQuery(db, "SELECT * FROM AISLE;")
nrow(instacart_aisle)
## [1] 134

# Se cargan el número de pasillos y se mira cuantos hay
instacart_product <- dbGetQuery(db, "SELECT * FROM PRODUCT;")
nrow(instacart_product)
## [1] 49688

# Se cargan las ventas de productos realizadas en instacart, que recogen la orden compra,
# el cliente, la hora, el producto que se compro, junto con el identificador del pasillo
# y departamento al que pertenece el producto
instacart_sales <- dbGetQuery(db, "SELECT * FROM SALES;")

# Numero de ventas de productos
nrow(instacart_sales)
## [1] 32434489

#install and load plyr
#install.packages("plyr")
#library(dplyr)

# Contar el número de clientes que hay
nrow(unique(instacart_sales %>% select(C_Customer_ID)))
## [1] 206209

# Contar el número de cestas de la compra que hay
nrow(unique(instacart_sales %>% select(O_Order_ID)))
## [1] 3214874

# Contar el número de productos vendidos
nrow(unique(instacart_sales %>% select(P_Product_ID)))
## [1] 49677

# Hay productos que nunca se han vendido por lo que se procede a borrarlos de la 
# lista de instacart_product
products_appear <- unique(instacart_sales %>% select(P_Product_ID))
instacart_product <- instacart_product[instacart_product$Product_ID 
                                            %in% products_appear$P_Product_ID,]




######################################
### Modificación de los datos

##### DUPLICADOS

# Se comprueban los productos si estan repitidos por nombre, esto se pude deber 
# a un cambio de id del producto a lo largo de la historia
nrow(unique(instacart_product %>% select(Product_Name)))
# [1] 49668

# Se recoge en una lista todos los duplicados existentes
duplicados <- instacart_product %>% group_by(Product_Name) %>% filter(n() > 1)
duplicados <- duplicados[order(duplicados$Product_Name,decreasing=TRUE),]


### Imagen duplicados_todos.png

# Se recogen en un dataframe los duplicados que hay que borrar
duplicados_remove <- instacart_product[duplicated(instacart_product$Product_Name),]
### duplicados_remove.png

# Se remueven los productos con el id duplicado de el dataset

instacart_product <- instacart_product[!instacart_product$Product_ID 
                                            %in% duplicados_remove$Product_ID, ]

# Se procede a sociar a los duplicados de nombre, el valor del más inferior para no perder datos
library(plyr)
instacart_sales$P_Product_ID <-  as.numeric(revalue(as.character(instacart_sales$P_Product_ID), 
            c("37850"="30596","40185"="20255","23394"="404","36421"="404","44425"="404",
                "38464"="21408","37093"="35348","22538"="18688","26336"="150")))


##### CREACION MATRIZ CUSTOMER x PRODUCT

# Se procede a modificar el dataframe de instacart_sales de tal forma que pase de:

# O_Order_ID  C_Customer_ID P_Product_ID D_Departament_ID A_Aisle_ID ......
# C_Customer_ID Product_Name

# Se seleccionan las columnas que se van a utilizar
instacart_subset <- instacart_sales %>% select(C_Customer_ID,P_Product_ID)

# Se crea una columna que combina los clientes y los productos
instacart_subset <- instacart_subset %>% mutate(dup = paste(C_Customer_ID,P_Product_ID,sep = ' '))

# Se eliminan todas las filas que estan duplicadas
instacart_subset <- instacart_subset[!duplicated(instacart_subset$dup),] %>% select(-dup)
# 32434489 => 13307927

# Se almacen los datos "C_Customer_ID","P_Product_ID"
write.csv(instacart_subset,"/home/gregor/Escritorio/Customer_Product_ID.csv", 
                                quote = FALSE, row.names = FALSE)

customer_product <- read.transactions('/home/gregor/Escritorio/Customer_Product_ID.csv', 
                        format = "single", sep=",",header=TRUE,cols = c("C_Customer_ID","P_Product_ID"))
customer_product
## 206209 transactions (rows) and
## 49668 items (columns)

# Ahora las cabeceras de la matriz son números por lo que se procede a establecerlas con los nombres de los productos
itemLabels(customer_product)

# Se guarda en una lista de números los ids de las cabeceras de las columnas
old_title <- itemLabels(customer_product)
# Se orde la lista de productos como el vector de old_title
instacart_product <- instacart_product[match(old_title,instacart_product$Product_ID),]
# Se seleccionan los nombres y se guarda con el mismo formato que old_names
new_titles <- unlist(instacart_product %>% select(Product_Name))
itemLabels(customer_product) <- new_titles

itemLabels(customer_product)


# Ahora se observa el sumario
summary(customer_product)

library("pryr")
object_size(customer_product)# 72 MB

# Se convierte en una matriz
rating_product <- as(customer_product,"binaryRatingMatrix")

# Para medir el tamaño de la matriz
object_size(rating_product) # 72 MB


min_product_binary <- quantile(rowCounts(rating_product), 0.9999)
min_customer_binary <- quantile(colCounts(rating_product), 0.9995)

image(rating_product[rowCounts(rating_product) > min_product_binary,
                             colCounts(rating_product) > min_customer_binary], 
                                    main = "Heatmap of the top clients and products")


##### CREACION MATRIZ MArket_basket

# Se procede a modificar el dataframe de instacart_sales de tal forma que pase de:

# O_Order_ID  C_Customer_ID P_Product_ID D_Departament_ID A_Aisle_ID ......
# O_Order_ID P_Product_ID

# Se seleccionan las columnas que se van a utilizar
instacart_subset <- instacart_sales %>% select(O_Order_ID,P_Product_ID)

# Se crea una columna que combina las prdenes y los productos
instacart_subset <- instacart_subset %>% mutate(dup = paste(O_Order_ID,P_Product_ID,sep = ' '))

# Se eliminan todas las filas que estan duplicadas
instacart_subset <- instacart_subset[!duplicated(instacart_subset$dup),] %>% select(-dup)

# Se almacen los datos "O_Order_ID","P_Product_ID"
write.csv(instacart_subset,"/home/gregor/Escritorio/Market_Basket.csv", 
                                quote = FALSE, row.names = FALSE)

market_basket <- read.transactions('/home/gregor/Escritorio/Market_Basket.csv', 
                    format = "single", sep=",",header=TRUE,cols = c("O_Order_ID","P_Product_ID"))
market_basket
# transactions in sparse format with
# 3214874 transactions (rows) and
# 49668 items (columns)

# Se guarda en una lista de números los ids de las cabeceras de las columnas
old_title <- itemLabels(market_basket)
# Se orde la lista de productos como el vector de old_title
instacart_product <- instacart_product[match(old_title,instacart_product$Product_ID),]
# Se seleccionan los nombres y se guarda con el mismo formato que old_names
new_titles <- unlist(instacart_product %>% select(Product_Name))
itemLabels(market_basket) <- new_titles


itemLabels(market_basket)

summary(market_basket)


#Se guarda el dataframe de productos en un fichero
write.csv(x=instacart_product,file='/home/gregor/Escritorio/instacart_product.csv',quote = FALSE, row.names = FALSE)

