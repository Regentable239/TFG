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

#########
## Preparar los datos para evaluar los modelos

# Para evaluar modelos, debe compilarlos con algunos datos y probarlos en algunos
# otros datos. Este cap�tulo le mostrar� c�mo preparar los dos conjuntos de datos. los
# El paquete recomenderlab contiene herramientas predise�adas que ayudan en esta tarea.


# El objetivo es definir dos conjuntos de datos, que son los siguientes:
#   . Conjunto de formaci�n: estos son los modelos de los que los usuarios aprenden
#   . Conjunto de prueba: estos son los modelos que los usuarios aplican y prueban
# Para evaluar los modelos, necesitamos comparar las recomendaciones con las
# Preferencias del usuario. Para hacerlo, debemos olvidarnos de algunas preferencias del usuario en
# el equipo de prueba y ver si las t�cnicas son capaces de identificarlos. Para cada usuario en
# el conjunto de prueba, ignoramos algunas compras y construimos las recomendaciones basadas en el
# otros. Carguemos los paquetes:

# El conjunto de datos que usaremos se llama MovieLense. Definamos ratings_movies
# que contiene solo los usuarios y las pel�culas m�s relevantes:

sub_rating_product <- rating_product[rowCounts(rating_product) > 120,
                                     colCounts(rating_product) > 750]
## 28372 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 3404722 ratings.


###########
### Splitting de los datos  (Training and TEst)

# La forma m�s sencilla de crear un conjunto de entrenamiento y prueba es dividir los datos en dos partes. Primero,
# tenemos que decidir cu�ntos usuarios poner en cada parte. Por ejemplo, podemos poner
# 80 por ciento de los usuarios en el conjunto de formaci�n. Podemos definir percent_training
# especificando el porcentaje del conjunto de entrenamiento:

percentage_training <- 0.8

# Para cada usuario en el conjunto de prueba, necesitamos definir cu�ntos elementos usar para generar
# recomendaciones. Los elementos restantes se utilizar�n para probar la precisi�n del modelo. Sus
# mejor que este par�metro sea menor que el n�mero m�nimo de art�culos comprados por
# cualquier usuario para que no tengamos usuarios sin elementos para probar los model

min(rowCounts(sub_rating_product))
## 18

# Por ejemplo, podemos guardar 15 art�culos:
items_to_keep <- 15

# Hay un par�metro adicional que define cu�ntas veces queremos ejecutar el
# evaluaci�n. Por el momento, configur�moslo en 1:
n_eval <- 1


# Estamos listos para dividir los datos. La funci�n recomenderlab es EvaluationScheme
# y sus par�metros son los siguientes:
#    . data: este es el conjunto de datos inicial
#    . method: esta es la forma de dividir los datos. En este caso, est� dividido
#    . train: este es el porcentaje de datos en el conjunto de entrenamiento
#    . given: este es el n�mero de elementos que se deben mantener
#    . goodRating: este es el umbral de calificaci�n inecesario al ser binaria
#    . k: este es el n�mero de veces que se ejecuta la evaluaci�n
# Construyamos eval_sets que contienen los conjuntos:

eval_sets <- evaluationScheme(data = sub_rating_product, method = "split",
                              train = percentage_training, given = items_to_keep, k = n_eval) 
eval_sets
# Evaluation scheme with 3 items given
# Method: ‘split’ with 1 run(s).
# Training set proportion: 0.800
# Good ratings: NA
# Data set: 28372 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 3404722 ratings.


# Para extraer los conjuntos, necesitamos usar getData. Hay tres conjuntos:
#   . train: este es el conjunto de entrenamiento
#   . known: este es el conjunto de prueba, con el elemento utilizado para crear las recomendaciones
#   . unknown: este es el conjunto de prueba, con el elemento utilizado para probar las recomendaciones

# Echemos un vistazo al conjunto de entrenamiento:

getData(eval_sets, "train")
## 22697 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 2728902 ratings.

nrow(getData(eval_sets, "train")) / nrow(sub_rating_product)
## [1] 0.7999789

# Como se esperaba, alrededor del 80 por ciento de los usuarios est�n en el conjunto de capacitaci�n. 
# Echemos un vistazo a los dos equipos de prueba:

getData(eval_sets, "known")
## 5675 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 85125 ratings.
getData(eval_sets, "unknown")
## 5675 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 590695 ratings.


# Ambos tienen el mismo n�mero de usuarios. Debe haber alrededor del 20 por ciento de los datos
# en el equipo de prueba:
nrow(getData(eval_sets, "known")) / nrow(sub_rating_product)
## [1] 0.2000211

# Todo es como se esperaba. Veamos cu�ntos elementos tenemos para cada usuario en el
# conjunto conocido. Debe ser igual a items_to_keep, es decir, 15:
unique(rowCounts(getData(eval_sets, "known")))
## [1] 15

# No ocurre lo mismo con los usuarios del conjunto de prueba, ya que el n�mero de elementos restantes
# depende del n�mero inicial de compras:

qplot(rowCounts(getData(eval_sets, "unknown"))) + 
  geom_histogram(binwidth = 10) + ggtitle("unknown items by the users")
### Iamgen: Evaluation scheme split

#################
### Bootstrapping de datos


# En la subsecci�n anterior, dividimos los datos en dos partes y el entrenamiento
# conjunto conten�a el 80 por ciento de las filas. �Qu� pasa si, en cambio, tomamos muestras de las filas con
# �reemplazo? El mismo usuario puede ser muestreado m�s de una vez y, si el entrenamiento
# conjunto tiene el mismo tama�o que ten�a antes, habr� m�s usuarios en el conjunto de prueba. Esta
# El enfoque se llama bootstrapping y es compatible con recomenderlab. los
# Los par�metros son los mismos que en el enfoque anterior. La �nica diferencia es que nosotros
# especificar m�todo = "bootstrap" en lugar de m�todo = "dividir":


percentage_training <- 0.8
items_to_keep <- 15
n_eval <- 1
eval_sets <- evaluationScheme(data = sub_rating_product, method = "bootstrap", 
                                train = percentage_training, given = items_to_keep,k = n_eval)


# El n�mero de usuarios en el conjunto de formaci�n sigue siendo igual al 80 por ciento del total:
nrow(getData(eval_sets, "train")) / nrow(sub_rating_product)
# [1] 0.7999789

# Sin embargo, no ocurre lo mismo con los elementos del conjunto de prueba:
perc_test <- nrow(getData(eval_sets, "known")) / nrow(sub_rating_product)
perc_test
## [1] 0.4534048

# El conjunto de prueba es m�s del doble de grande que el conjunto anterior.
# Podemos extraer los usuarios �nicos en el conjunto de entrenamiento:
length(unique(eval_sets@runsTrain[[1]]))
# [1] 15508

# El porcentaje de usuarios �nicos en el conjunto de formaci�n debe ser complementario al
# porcentaje de usuarios en el conjunto de prueba, que se muestra a continuaci�n:
perc_train <- length(unique(eval_sets@runsTrain[[1]])) / nrow(sub_rating_product)
perc_train + perc_test
## [1] 1

# Podemos contar cu�ntas veces se repite cada usuario en el conjunto de entrenamiento:
table_train <- table(eval_sets@runsTrain[[1]])
n_repetitions <- factor(as.vector(table_train))
qplot(n_repetitions) + ggtitle("Number of repetitions in the training set")
### Imagen: evaluationscheme_bootstrapping

#######################
### Using k-fold to validate models

# Los dos enfoques anteriores probaron el recomendador por parte de los usuarios.
# Si, en cambio, probamos la recomendaci�n en cada usuario, podr�amos medir la
# actuaciones con mucha m�s precisi�n. Podemos dividir los datos en algunos trozos, tome un
# fragmentar como conjunto de prueba y evaluar la precisi�n. Entonces, podemos hacer lo mismo con
# se fragmentan y calculan la precisi�n media. Este enfoque se llama k-fold
# y est� respaldado por recomenderlab.

# Podemos usar EvaluationScheme y la diferencia es que, en lugar de especificar el
# porcentaje de datos para poner en el conjunto de entrenamiento, definiremos cu�ntos fragmentos
# desear. El argumento es k, como el n�mero de repeticiones en los ejemplos anteriores.
# Claramente, ya no necesitamos especificar train:

n_fold <- 4
eval_sets <- evaluationScheme(data = sub_rating_product, method = "cross-validation",
                              k = n_fold, given = items_to_keep)

# Podemos contar cu�ntos elementos tenemos en cada conjunto:
size_sets <- sapply(eval_sets@runsTrain, length)
size_sets
## [1] 21279 21279 21279 21279


# Como era de esperar, todos los conjuntos tienen el mismo tama�o.
# Este enfoque es el m�s preciso, aunque computacionalmente m�s pesado.
# En este cap�tulo, hemos visto diferentes enfoques para preparar la capacitaci�n y la prueba.
# conjunto. En el pr�ximo cap�tulo, comenzaremos con la evaluaci�n.


######
## Evaluating the ratings

# Para recomendar elementos a nuevos usuarios, el filtrado colaborativo estima el
# calificaciones de art�culos que a�n no se han comprado. Luego, recomienda las mejores
# art�culos. Por el momento, olvid�monos del �ltimo paso. Podemos evaluar el modelo por
# comparando las calificaciones estimadas con las reales.

# Primero, preparemos los datos para la validaci�n, como se muestra en la secci�n anterior. Desde el
# k-fold es el enfoque m�s preciso, lo usaremos aqu�:
n_fold <- 4
items_to_keep <- 15
eval_sets <- evaluationScheme(data = sub_rating_product, method = "cross-validation",
                              k = n_fold, given = items_to_keep)
eval_sets
# Evaluation scheme with 15 items given
# Method: ‘cross-validation’ with 4 run(s).
# Good ratings: NA
# Data set: 28372 x 3379 rating matrix of class ‘binaryRatingMatrix’ with 3404722 ratings.


models_to_evaluate <- list(
  random = list(name = "RANDOM", param=NULL),
  IBCF_cos = list(name = "IBCF", param = list(method = "Jaccard")),
  UBCF_cos = list(name = "UBCF", param = list(method = "Jaccard"))
)

# Para evaluar los modelos correctamente, necesitamos probarlos, variando el número
# de artículos. Por ejemplo, es posible que deseemos recomendar hasta 100 productos 
# a cada usuario. Dado que 100 ya es una gran cantidad de recomendaciones, no 
# se necesita incluir valores m�s altos:
n_recommendations <- c(1, 5, seq(10, 100, 10))

# la función es evaluar y se le pasa como parametro una lista de modelos:
list_results <- evaluate(x = eval_sets, method = models_to_evaluate, n
                         = n_recommendations)
class(list_results)
## evaluationResultList


# El objeto list_results es un objeto EvaluationResultList y se puede tratar
# como una lista. Echemos un vistazo a su primer elemento:
class(list_results[[1]])
## evaluationResults


# El primer elemento de list_results es un objeto EvaluationResults, y este objeto
# es el mismo que el resultado de evaluar con un solo modelo. Podemos comprobar si el
# lo mismo es cierto para todos sus elementos:
sapply(list_results, class) == "evaluationResults"
# random IBCF_cos UBCF_cos 
# TRUE     TRUE     TRUE 

# Cada elemento de list_results es un objeto EvaluationResults. Podemos extraer el
# matrices de confusi�n promedio relacionadas usando avg:
avg_matrices <- lapply(list_results, avg)

# Podemos usar avg_matrices para explorar la evaluaci�n del desempe�o. Por ejemplo, vamos
# Eche un vistazo al IBCF con distancia coseno:
head(avg_matrices$IBCF_cos[, 5:8])

#### Metricas_2

# Tenemos todas las m�tricas del cap�tulo anterior. En la siguiente secci�n, exploraremos
# estas m�tricas para identificar el modelo de mejor rendimiento.

################
### Identificar el modelo m�s adecuado

# Podemos comparar los modelos construyendo un gr�fico que muestre sus curvas ROC. Me gusta
# la secci�n anterior, podemos usar plot. El argumento anotar especifica qu�
# las curvas contendr�n las etiquetas. Por ejemplo, la primera y segunda curvas est�n etiquetadas
# definiendo annotate = c (1, 2). En nuestro caso, etiquetaremos solo la primera curva:

plot(list_results, annotate = 1, legend = "topleft") + title("ROC curve")

# Un buen �ndice de rendimiento es el �rea bajo la curva (AUC), es decir, el �rea bajo
# la curva ROC. Incluso sin calcularlo, podemos notar que el m�s alto es UBCF
# con la distancia del coseno, por lo que es la t�cnica de mejor rendimiento.
# Como hicimos en la secci�n anterior, podemos construir el gr�fico de recuperaci�n de precisi�n:
plot(list_results, "prec/rec", annotate = 1, legend = "bottomright") + title("Precision-recall")

# El UBCF con distancia de coseno sigue siendo el modelo superior. Dependiendo de lo que queramos
# lograr, podemos establecer una cantidad adecuada de elementos para recomendar.

###############
## Optimizing a numeric parameter

# Los modelos de recomendaci�n suelen contener algunos par�metros num�ricos. Por ejemplo, IBCF
# tiene en cuenta los elementos k m�s cercanos. �C�mo podemos optimizar k?
# 
# De manera similar a los par�metros categ�ricos, podemos probar diferentes valores de un
# par�metro. En este caso, tambi�n necesitamos definir qu� valores queremos probar.
# 
# Hasta ahora, dejamos k en su valor predeterminado: 30. Ahora, podemos explorar más valores, que van
# entre 5 y 40:


vector_k <- c(5, 10, 20, 30, 40)

models_to_evaluate <- lapply(vector_k, function(k){
  list(name = "IBCF", param = list(method = "cosine", k = k))
})
names(models_to_evaluate) <- paste0("IBCF_k_", vector_k)

# Usando los mismos comandos que hicimos antes, construyamos y evaluemos los modelos:

n_recommendations <- c(1, 5, seq(10, 100, 10))
list_results <- evaluate(x = eval_sets, method = models_to_evaluate, n
                         = n_recommendations)


plot(list_results, annotate = 1, legend = "topleft") + title("ROC curve")
# ROC_CURVE_Optimizada.png


plot(list_results, "prec/rec", annotate = 1, legend = "bottomright") + title("Precision-recall")
# Precision-recall_Optimizado.png