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

#Se leen las cestas de la compra
market_basket <- read.transactions('/home/gregor/Escritorio/Market_Basket.csv', format = "single", sep=",",header=TRUE,cols = c("O_Order_ID","P_Product_ID"))
market_basket
# transactions in sparse format with
# 3214874 transactions (rows) and
# 49668 items (columns)

# Se cargan la lista de productos con identificadores y nombres
instacart_product <- read.csv(file='/home/gregor/Escritorio/instacart_product.csv')
# 49668

# Se guarda en una lista de números los ids de las cabeceras de las columnas
old_title <- itemLabels(market_basket)
# Se orde la lista de productos como el vector de old_title
instacart_product <- instacart_product[match(old_title,instacart_product$Product_ID),]
# Se seleccionan los nombres y se guarda con el mismo formato que old_names
new_titles <- unlist(instacart_product %>% select(Product_Name))
itemLabels(market_basket) <- new_titles
itemLabels(market_basket)


################## 
# Visualización tamaño de las transacciones y reparto de los datos

# Tamaño de las transacciones
tamanyos <- size(market_basket)
summary(tamanyos)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.00    5.00    8.00   10.09   14.00  145.00 

# Repartición de los datos en porcentajes de 10
quantile(tamanyos, probs = seq(0,1,0.1))
# 0%  10%  20%  30%  40%  50%  60%  70%  80%  90% 100% 
# 1    2    4    5    7    8   10   12   15   20  145 

# La mayoría de clientes compraron entre 10 y 12 productos
# el 90% de ellos compra como máximo 30.
 


options(scipen=999) # Eliminar la notación cientifica
coul <- brewer.pal(8, "Set2")  # Select color values

data.frame(tamanyos) %>%
  ggplot(aes(x = tamanyos)) +
  geom_histogram() + 
  # geom_boxplot() +
  labs(title = "Distribución del tamaño de las transacciones",
       x = "Tamaño") +
  theme_bw()

#### Diagrama de caja
data.frame(tamanyos) %>%
  ggplot(aes(x = tamanyos)) +
  geom_boxplot() +
  labs(title = "Distribución del tamaño de las transacciones",
       x = "Tamaño") +
  theme_bw()

# Por "frecuencia" se hace referencia al soporte de cada item, que es la fracci?n de transacciones 
# que contienen dicho item respecto al total de todas las transacciones. Esto es distinto a la 
# frecuencia de un item respecto al total de items, de ah? que la suma de todos los soportes no sea 1.

frecuencia_items <- itemFrequency(x = market_basket, type = "relative")
frecuencia_items %>% sort(decreasing = TRUE) %>% head(5)

# Banana           Bag of Organic Bananas   Organic Strawberries   Organic Baby Spinach   Organic Hass Avocado 
# 0.14699332             0.11802951             0.08233075             0.07525054             0.06643620 

itemFrequencyPlot(market_basket,topN=20,type="relative",col=brewer.pal(8,'Greens'),main="Relative Item Frequency Plot")

# Type absoluto indica el n?mero de elementos 
frecuencia_items <- itemFrequency(x = market_basket, type = "absolute")
frecuencia_items %>% sort(decreasing = TRUE) %>% head(5)

# Banana          Bag of Organic Bananas   Organic Strawberries   Organic Baby Spinach   Organic Hass Avocado 
# 472565                 379450                 264683                 241921                 213584 

itemFrequencyPlot(market_basket,topN=20,type="absolute",col=brewer.pal(8,'Greens'),main="Relative Num Products Plot")


############ Mirando las ventas

# Numero de ventas por producto
tamanyos <- itemFrequency(x = market_basket, type = "absolute")
summary(tamanyos)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1      17      60     653     260      472565 

# Numero de ventas por producto
quantile(tamanyos, probs = seq(0,1,0.1))
# 0%    10%    20%    30%    40%    50%    60%    70%    80%    90%   100% 
# 1      7     13     22     36     60    102    185    377   1021 472565 

# 49668 productos aproximadamente 5000 (10%) se ha vendido mas de 1021 veces

##############
### Itemset

# Se procede a extraer aquellos itemsets, incluidos los formados por un único item, 
# que hayan sido comprados al menos 7500 veces.

soporte <- 7500 / dim(market_basket)[1]  #0,0023
itemsets <- apriori(data = market_basket,
                    parameter = list(support = soporte,
                                     minlen = 1,
                                     maxlen = 20,
                                     target = "frequent itemset"))

summary(itemsets)
### Imagen: Summary_1

# En el siguiente listado se muestran los 20 itemsets con mayor soporte que, como cabe esperar, 
# son los formados por items individuales
top_20_itemsets <- sort(itemsets, by = "support", decreasing = TRUE)[1:20]
inspect(top_20_itemsets)
## Imagen: 20_ites_con_mayor_soporte

# Para representarlos con ggplot se convierte a dataframe 
as(top_20_itemsets, Class = "data.frame") %>%
  ggplot(aes(x = reorder(items, support), y = support)) +
  geom_col() +
  coord_flip() +
  labs(title = "Itemsets más frecuentes", x = "itemsets") +
  theme_bw()
## Iamgen: 20_items_graph_soporte


# Se muestran los 20 itemsets m?s frecuentes formados por m?s de un item.
inspect(sort(itemsets[size(itemsets) > 1], decreasing = TRUE)[1:20])
### Imagen: 20_con_mas_de_un_item.png

#######
#  Reglas de asociaci?n

soporte <- 0.00001 
confianza <- 0.50
reglas <- apriori(data = market_basket,
                  parameter = list(support = soporte,
                                   confidence = confianza,
                                   # Se especifica que se creen reglas
                                   target = "rules"))


summary(reglas)

# Se han identificado un total de 19 reglas, la mayor?a de ellas formadas por 4 items en 
# el antecedente (parte izquierda de la regla).
inspect(sort(x = reglas, decreasing = TRUE, by = "confidence")[1:10])

##########
## Evaluación de las reglas

# Se establece la notación científica
options(scipen=5)

metricas <- interestMeasure(reglas, measure = c("coverage", "fishersExactTest"),
                            transactions = market_basket)
metricas[1:10,]
## Imagen: metricas_1.png


quality(reglas) <- cbind(quality(reglas), metricas)
# inspect(sort(x = reglas, decreasing = TRUE, by = "confidence"))
df_reglas <- as(reglas, Class = "data.frame") 
df_reglas %>% as.tibble() %>% arrange(desc(confidence)) %>% head(10)
### Image: rules_study.png

############
### Filtrado de reglas

# Restringir las reglas que se crean
# 
# Es posible restringir los items que aparecen en el lado izquierdo y/o derecho de la reglas a la hora de crearlas, 
# por ejemplo, sup?ngase que solo son de inter?s reglas que muestren productos que se vendan junto con other vegetables.
# Esto significa que el item other vegetables, debe aparecer en el lado derecho (rhs).

soporte <- 0.00001
reglas_banana <- apriori(data = market_basket,
                             parameter = list(support = soporte,
                                              confidence = 0.40,
                                              # Se especifica que se creen reglas
                                              target = "rules"),
                             appearance = list(rhs = "Banana"))

summary(reglas_banana)

inspect(reglas_banana[1:10])



# Reglas maximales
# 
# Un itemset es maximal si no existe otro itemset que sea su superset. Una regla de asociaci?n se define como regla 
# maximal si est? generada con un itemset maximal. Con la funci?n is.maximal() se pueden identificar las reglas maximales.

reglas_maximales <- reglas[is.maximal(reglas)]
reglas_maximales

### 293 de 293 reglas

# Reglas redundantes
# 
# Dos reglas son id?nticas si tienen el mismo antecedente (parte izquierda) y consecuente (parte derecha). Sup?ngase 
# ahora que una de estas reglas tiene en su antecedente los mismos items que forman el antecedente de la otra, junto 
# con algunos items m?s. La regla m?s gen?rica se considera redundante, ya que no aporta informaci?n adicional. 
# En concreto, se considera que una regla X => Y es redundante si existe un subset X' tal que existe 
# una regla X' => Y cuyo soporte es mayor.

# X => Y es redundante si existe un subset X' tal que: conf(X' -> Y) >= conf(X -> Y)

reglas_redundantes <- reglas[is.redundant(x = reglas, measure = "confidence")]
reglas_redundantes
# set of 0 rules 

###################
## Poda de reglas redundantes

# Entre las reglas generadas, a veces encontramos reglas repetidas o redundantes (por ejemplo,
# una regla es la superregla o subconjunto de otra regla). En esta receta, le mostraremos c�mo
# pode (o elimine) las reglas repetidas o redundantes.

# Primero, siga estos pasos para encontrar reglas redundantes:
# 1) Ordenar las reglas por la métrica que se desee
reglas.sorted <- sort(reglas, by="lift") 
# 2) Crear una matriz de una regla x reglas
subset.matrix <- is.subset(reglas.sorted, reglas.sorted)
# 3) establecer esa matriz como una matriz de lógicas
subset.matrix[lower.tri(subset.matrix, diag=TRUE)] <- 0
# 4) Si en una fila hay más de un acierto es que coinciden 
#    algunas reglas.
redundant <- colSums(subset.matrix, na.rm=T) >= 1

# A continuación, puede eliminar las reglas redundantes:
reglas.pruned <- reglas.sorted[!redundant]
inspect(head(reglas.pruned))

reglas         # set of 293 rules 
reglas.pruned  # set of 286 rules

##################
### Visualizaci�n de reglas de asociaci�n


# Adem�s de enumerar las reglas como texto, puede visualizar las reglas de asociaci�n, lo que facilita la b�squeda
# la relaci�n entre conjuntos de elementos. En la siguiente receta, presentaremos c�mo usar
# el paquete aruleViz para visualizar las reglas de asociaci�n.

# install.packages("arulesViz")
library(arulesViz)



plot(reglas.pruned)
## Image: plot_rules

# Adem�s, para evitar el trazado excesivo, puede agregar jitter al gr�fico de dispersi�n:
plot(reglas.pruned, shading="order", control=list(jitter=6))
## Image: plot_rules_1

# Adem�s de generar una gr�fica est�tica, puede generar una gr�fica interactiva mediante
# estableciendo interactivo igual a TRUE a trav�s de los siguientes pasos:
plot(reglas.pruned,interactive=TRUE)

############
## Extraer conjuntos de elementos frecuentes con Eclat

# Adem�s del algoritmo Apriori, puede utilizar el algoritmo Eclat para generar frecuentes
# conjuntos de elementos. Como el algoritmo Apriori realiza una b�squeda en amplitud para escanear la base de datos completa,
# el recuento del soporte lleva bastante tiempo. Alternativamente, si la base de datos cabe en la memoria,
# puede utilizar el algoritmo Eclat, que realiza una b�squeda en profundidad para contar los apoyos.
# El algoritmo Eclat, por lo tanto, funciona m�s r�pido que el algoritmo Apriori. En esta receta,
# introducir c�mo utilizar el algoritmo Eclat para generar conjuntos de elementos frecuentes.

# Similar al método Apriori, podemos usar la función eclat para generar 
# el conjunto de elementos frecuentes:

frequentsets=eclat(market_basket,parameter=list(support=0.05,maxlen=10))

summary(frequentsets)

inspect(sort(frequentsets,by="support"))