# Libraries
library("RMariaDB")
library(arules)
library(arulesViz)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(plyr)
library(dplyr)
library(skimr)
library(treemap)
library(data.table)
library(recommenderlab)
library(tictoc)
library("RColorBrewer")


# Se cargan los datos que se van a utilizar

system.time(customer_product <- read.transactions('/home/gregor/Escritorio/Customer_Product_ID.csv', format = "single", sep=",",header=TRUE,cols = c("C_Customer_ID","P_Product_ID")))
# user  system elapsed 
# 15.895   0.316  16.209 

customer_product
## 206209 transactions (rows) and
## 49668 items (columns)

# Se cargan la lista de productos con identificadores y nombres
instacart_product <- read.csv(file='/home/gregor/Escritorio/instacart_product.csv')

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
object_size(customer_product) # 72 MB

# Se convierte en una matriz
rating_product <- as(customer_product,"binaryRatingMatrix")

object_size(rating_product) # 72 MB
# Si fuese una matriz normal ocuparia 10 veces mas unos 720 Mb

####### ---------------
## Explorar los datos

############ Explorando que productos se han vendido mas

#   . colCounts: este es el número de valores que no faltan para cada columna
#   . colMeans: este es el valor promedio de cada columna

views_per_product <- colCounts(rating_product)

table_views_product <- data.frame(
  product = names(views_per_product),
  sales = views_per_product
)
table_views_product <- table_views_product[order(table_views_product$sales, decreasing = TRUE), ]

ggplot(table_views_product[1:6, ], aes(x = product, y = sales, fill=product)) +
  geom_bar(stat="identity") + scale_fill_brewer(palette = "GnBu") + theme(axis.text.x =
                                      element_text(angle = 45, hjust = 1)) + 
                                      ggtitle("Number of sales of the top products")



quantile(views_per_product, probs = seq(0,1,0.1))
# 0%   10%   20%   30%   40%   50%   60%   70%   80%   90%  100% 
# 1     5     9    14    23    35    57   100   194   491 73956

############ Explorando qué clientes han comprado más

#   . colrows: este es el n�mero de valores que no faltan para cada columna
#   . colMeans: este es el valor promedio de cada columna

views_per_client <- rowCounts(rating_product)

table_views_client <- data.frame(
  client = names(views_per_client),
  sales = views_per_client
)
table_views_client <- table_views_client[order(table_views_client$sales, decreasing = TRUE), ]

ggplot(table_views_client[1:6, ], aes(x = client, y = sales, fill=client)) +
  geom_bar(stat="identity") + scale_fill_brewer(palette = "GnBu") + theme(axis.text.x =
                element_text(angle = 45, hjust = 1)) + ggtitle("Number of sales of the top client")

quantile(views_per_client, probs = seq(0,1,0.1))
# 0%  10%  20%  30%  40%  50%  60%  70%  80%  90% 100% 
# 1   13   21   29   38   48   60   76   99  139  726 

####### ---------------
## Visualizando la matriz

# Algunos usuarios vieron m�s pel�culas que otros. Sin embargo, este gr�fico solo muestra
# algunos usuarios y elementos aleatorios. �Qu� pasa si, en cambio, seleccionamos los usuarios m�s relevantes y
# �art�culos? Esto significa visualizar solo a los usuarios que han visto muchas pel�culas y la
# pel�culas que han visto muchos usuarios. Identificar y seleccionar los m�s relevantes
# usuarios y pel�culas, siga estos pasos:
#   1. Determine la cantidad m�nima de pel�culas por usuario.
#   2. Determine el n�mero m�nimo de usuarios por pel�cula.
#   3. Seleccione los usuarios y las pel�culas que coincidan con estos criterios.

# Por ejemplo, podemos visualizar el percentil superior de usuarios y pel�culas. Con el fin de hacer
# esto, usamos la funci�n quantile:

min_movies_binary <- quantile(rowCounts(rating_product), 0.9999)
min_users_binary <- quantile(colCounts(rating_product), 0.9995)

image(rating_product[rowCounts(rating_product) > min_movies_binary,
                     colCounts(rating_product) > min_users_binary], main = "Heatmap of the top client and product")

####### ---------------
## Preparaci�n de los datos (Selecionar los datos relevante y normalizar)

### Venta de productos
# 0%   10%   20%   30%   40%   50%   60%   70%   80%   90%  100% 
# 1     5     9    14    23    35    57   100   194   491 73956

### Productos comprados por cliente
# 0%  10%  20%  30%  40%  50%  60%  70%  80%  90% 100% 
# 1   13   21   29   38   48   60   76   99  139  726 

# Definiremos sub_rating_product que contienen la matriz que usaremos. Se necesita
# cuenta de:
#   . Clientes que han comprado al menos 120 productos
#   . Productos que se han comprado al menos 750 veces


sub_rating_product <- rating_product[rowCounts(rating_product) > 120,                 # 60(60%) | 76(70%) | 99 (80%) | 120 (85½)
                                     colCounts(rating_product) > 750]                 # 23(40%) | 194(80%) | 350 (85%) | 750 (92%)
rating_product
sub_rating_product

# 206209 x 49668 rating matrix of class ‘binaryRatingMatrix’ with 13307927 ratings.
# 81336 x 29308 rating matrix of class ‘binaryRatingMatrix’ with 9380409 ratings.
# 61144 x 9931 rating matrix of class ‘binaryRatingMatrix’ with 7132553 ratings.
# 40745 x 6530 rating matrix of class ‘binaryRatingMatrix’ with 5131761 ratings.
# 28372 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 3404722 ratings.

min_movies_binary <- quantile(rowCounts(sub_rating_product), 0.9995)
min_users_binary <- quantile(colCounts(sub_rating_product), 0.999)

image(sub_rating_product[rowCounts(sub_rating_product) > min_movies_binary,
                     colCounts(sub_rating_product) > min_users_binary], main = "Heatmap of the top client and product")

########################
## Item-based collaborative filtering

################
# Definir el modelo de entrenamiento y de tipo test 

# Los dos conjuntos son los siguientes:
#   . Conjunto de formación: este conjunto incluye clientes de los que aprende el modelo.
#   . Conjunto de prueba: este conjunto incluye clientes a los que recomendamos productos

# Productos comprados por cliente
qplot(rowSums(sub_rating_product)) + stat_bin(binwidth = 10) + 
  geom_vline(xintercept = mean(rowSums(sub_rating_product)), col = "red", linetype = "dashed") + 
  ggtitle("Distribution of product by client")

# En promedio, cada cliente compro entorno a 120 productos y solo unos pocos compraron mas de 200 productos.
# Para construir un modelo de recomendaci�n, definamos un conjunto de entrenamiento y un conjunto de prueba:

which_train <- sample(x = c(TRUE, FALSE), size = nrow(sub_rating_product),
                      replace = TRUE, prob = c(0.8, 0.2))
recc_data_train <- sub_rating_product[which_train, ]
recc_data_test <- sub_rating_product[!which_train, ]


###############
# Construir el sistema de recomendaci�n

# La función para construir modelos es Recommender y sus entradas son las siguientes:
#   . Data: este es el conjunto de entrenamiento
#   . Method: este es el nombre de la t�cnica
#   . Parameter: Estos son algunos par�metros opcionales de la t�cnica.

# Podemos construir el modelo de filtrado IBCF usando los mismos comandos que en RealRatingMatrix
# La única diferencia es el método de parámetro de entrada es Jaccard:

system.time(recc_model_IBCF <- Recommender(data = recc_data_train, method = "IBCF",
                          parameter = list(method = "Jaccard")))
# user  system elapsed 
# 419.737   2.366 422.050 

###############
## Aplicar el modelo de recomendaci�n en la prueba conjunto

# Ahora, podemos recomendar pel�culas a los usuarios en el conjunto de prueba. Nosotros definiremos
# n_recommended que especifica la cantidad de elementos que se recomendar�n a cada usuario. Esta
# La secci�n le mostrar� el enfoque m�s popular para calcular una suma ponderada:

n_recommended <- 6

# Luego, el algoritmo identifica las n recomendaciones principales:
system.time(recc_predicted_IBCF <- predict(object = recc_model_IBCF,
                          newdata = recc_data_test,n = n_recommended))
# user  system elapsed 
# 15.294   2.980  18.314 

recc_matrix_IBCF <- sapply(recc_predicted_IBCF@items, function(x){
  colnames(sub_rating_product)[x]
})

dim(recc_matrix_IBCF)
# [1]    6 5663

recc_matrix_IBCF[, 1:4]

# Ahora, podemos identificar los productos mas recomendados. Para ello, haremos
# define un vector con todas las recomendaciones, y construiremos una gráfica de frecuencia:

number_of_items <- factor(table(recc_matrix_IBCF))
chart_title <- "Distribution of the number of items for IBCF"

qplot(number_of_items) + ggtitle(chart_title)
## Image: products_more_recommended

# La mayor�a de los productos se han recomendado solo unas pocas veces y algunos productos
# Se han recomendado muchas veces. Veamos cu�les son las productos m�s populares:

number_of_items_sorted <- sort(number_of_items, decreasing = TRUE)
number_of_items_top <- head(number_of_items_sorted, n = 4)
table_top <- data.frame(names(number_of_items_top),
                        number_of_items_top)
table_top


# 
########################
### User-based collaborative filtering

# De manera similar a IBCF, necesitamos usar el �ndice Jaccard para UBCF. Dados dos usuarios, el
# El �ndice se calcula como el n�mero de art�culos comprados por ambos usuarios dividido por
# el n�mero de art�culos comprados por al menos uno de ellos. Los simbolos matematicos
# son los mismos que en la secci�n anterior:

system.time(recc_model_UBCF <- Recommender(data = recc_data_train, method = "UBCF",
                          parameter = list(method = "Jaccard")))
# user  system elapsed 
# 0.001   0.000   0.001 

n_recommended <- 6

system.time(recc_predicted_UBCF <- predict(object = recc_model_UBCF,
                          newdata = recc_data_test,n = n_recommended))
# user  system elapsed 
# 824.567   8.593 833.016 

recc_matrix_UBCF  <- sapply(recc_predicted_UBCF@items, function(x){
  colnames(sub_rating_product)[x]
})

dim(recc_matrix_UBCF)
## [1] 6 109
recc_matrix_UBCF[, 1:4]

# Tambi�n podemos calcular cu�ntas veces se recomend� cada producto y crear el
# histograma de frecuencia relacionado
number_of_items <- factor(table(recc_matrix_UBCF))
chart_title <- "Distribution of the number of items for UBCF"

qplot(number_of_items) + ggtitle(chart_title)

# En comparaci�n con el IBCF, la distribuci�n tiene una cola m�s larga. Esto significa que hay
# algunas pel�culas que se recomiendan con mucha m�s frecuencia que otras. El maximo
# es 29, en comparaci�n con 11 para IBCF.

number_of_items_sorted <- sort(number_of_items, decreasing = TRUE)
number_of_items_top <- head(number_of_items_sorted, n = 4)
table_top <- data.frame(names(number_of_items_top), number_of_items_top)
table_top






