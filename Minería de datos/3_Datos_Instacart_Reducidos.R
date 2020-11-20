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

# Conexión a la base de datos
db <- dbConnect(RMariaDB::MariaDB(), 
                host = "127.0.0.1", 
                user = "root", 
                password = "Parago21", 
                dbname = "Instacart")

# Se cargan el número de pasillos y se mira cuantos hay
instacart_product <- dbGetQuery(db, "SELECT * FROM PRODUCT;")
nrow(instacart_product)
## [1] 49688

# Se cargan las ventas de productos realizadas en instacart, que recogen la orden compra,
# el cliente, la hora, el producto que se compro, junto con el identificador del pasillo
# y departamento al que pertenece el producto
instacart_sales <- dbGetQuery(db, "SELECT * FROM SALES;")
nrow(instacart_sales)
## [1] 32434489

# hay productos que nunca se han vendido por lo que se procede a borrarlos
# de la lista de instacart_product
products_appear <- unique(instacart_sales %>% select(P_Product_ID))
instacart_product <- instacart_product[instacart_product$Product_ID %in% products_appear$P_Product_ID,]

##### DUPLICADOS

# Se comprueban los productos si estan repitidos por nombre, estyo se pude deber a un cambio de id del
# producto a lo largo de la historia
nrow(unique(instacart_product %>% select(Product_Name)))
# [1] 49668

# Se recoge en una lista todos los duplicados existentes
duplicados <- instacart_product %>% group_by(Product_Name) %>% filter(n() > 1)
duplicados <- duplicados[order(duplicados$Product_Name,decreasing=TRUE),]
### Imagen duplicados_todos.png

# Se recogen en un dataframe los duplicados que hay que borrar
duplicados_remove <- instacart_product[duplicated(instacart_product$Product_Name),]
### duplicados_remove.png

# Se remueven los prudctos con el id duplicado de el dataset
instacart_product <- instacart_product[!instacart_product$Product_ID %in% duplicados_remove$Product_ID, ]

# Se procede a sociar a los duplicados de nombre, el valor del más inferior para no perder datos
library(plyr)
instacart_sales$P_Product_ID <-  as.numeric(revalue(as.character(instacart_sales$P_Product_ID), c("37850"="30596","40185"="20255","23394"="404","36421"="404","44425"="404","38464"="21408","37093"="35348","22538"="18688","26336"="150")))


###########
### Se van a dividir el tamaño de las transiciones de ventas, para ellos se eliminaran los productos con
### pocas apariciones

# Se añaden las frecuencias de venta de cada producto en una columna nueva 
# y se ordena de manera descendente basandose en la frecuencia
instacart_subset <- instacart_sales %>% select(P_Product_ID)
instacart_subset <- data.frame(table(instacart_subset$P_Product_ID))
instacart_subset <- instacart_subset[order(instacart_subset$Freq,decreasing=TRUE),]

# Una vez han sido ordenados se les añade un valor que representa
# la posción que ocupan con respecto al número de ventas
instacart_subset$Position <- seq.int(nrow(instacart_subset))
instacart_subset$Freq <- NULL
names(instacart_subset)[names(instacart_subset) == "Var1"] <- "P_Product_ID"

# Se le añade el item de la posición que ocupa a la tabla sales
reduce_sales <- merge(instacart_sales %>% select(P_Product_ID),instacart_subset, by = "P_Product_ID")

# Se observa donde se encuentran la mayoría de los datos

quantile(reduce_sales$Position)
# 0%   25%   50%   75%  100% 
# 1   121   787  3349 49668

quantile(reduce_sales$Position, probs = seq(0,1,0.05))
# 0%    5%   10%   15%   20%   25%   30%   35%   40%   45%   50%   55%   60%   65%   70%   75%   80%   85%   90%   95%  100% 
# 1     6    19    42    73   121   190   286   412   575   787  1062  1420  1887  2507  3349  4538  6290  9151 14816 49668 

# El 80% de los datos que se tienen comprados corresponden a tan solo 4538 son el 0,09% de los datos (Total=49668)


# inferior, izquierda, superior, derecha, => margenes
par(mar=c(10,5,3,1)+.1)
options(scipen=1)
hist(x = reduce_sales$Position,las=2,main="Num values descending for position",xlab="Position",ylab="",col="Darkblue" )
## Imagen: Frecuency_postion_histogram

##########
##

# Se seleccionan solo aquellos productos con una posición menor 4538 el 80% el total de ventas
instacart_subset <- subset(instacart_subset,instacart_subset$Position <= 4538)
sales_filter <- instacart_sales[(as.character(instacart_sales$P_Product_ID) %in% as.character(instacart_subset$P_Product_ID)),]
sales_filter <- sales_filter %>% select(O_Order_ID,P_Product_ID)
# de 32.434.489 => 25.947.840 ventas de productos y de 49668 => 4538 productos

# Se crea una columna que convina los clientes y los productos
sales_filter <- sales_filter %>% mutate(dup = paste(O_Order_ID,P_Product_ID,sep = ' '))

# Se eliminan todas las filas que estan duplicadas
sales_filter <- sales_filter[!duplicated(sales_filter$dup),] %>% select(-dup)

# Se almacen los datos "O_Order_ID","P_Product_ID"
write.csv(sales_filter,"/home/gregor/Escritorio/Sub_Market_Basket.csv", quote = FALSE, row.names = FALSE)


#Se guarda el dataframe de sub productos en un fichero (4538)
sub_products <- instacart_product[(as.character(instacart_product$Product_ID) %in% as.character(instacart_subset$P_Product_ID)),]
write.csv(x=sub_products,file='/home/gregor/Escritorio/sub_instacart_product.csv',quote = FALSE, row.names = FALSE)


sub_market_basket <- read.transactions('/home/gregor/Escritorio/Sub_Market_Basket.csv', format = "single", sep=",",header=TRUE,cols = c("O_Order_ID","P_Product_ID"))
sub_market_basket
# transactions in sparse format with
# 3151202 transactions (rows) and
# 4538 items (columns)

# 3214874 transactions => 3151202 transactions
# 49668 items => 4538 items


# Se guarda en una lista de números los ids de las cabeceras de las columnas
old_title <- itemLabels(sub_market_basket)
# Se orde la lista de productos como el vector de old_title
sub_products <- sub_products[match(old_title,sub_products$Product_ID),]
# Se seleccionan los nombres y se guarda con el mismo formato que old_names
new_titles <- unlist(sub_products %>% select(Product_Name))
itemLabels(sub_market_basket) <- new_titles
itemLabels(sub_market_basket)

summary(sub_market_basket)























