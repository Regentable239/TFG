import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/DATA/instacart_2017_05_01/order_edit.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Instacart;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    tupla="INSERT INTO ORDERS (Order_ID, Days_since_prior_order) VALUES (" + lista[0] + ",\"" + lista[1] + "\");"
    print(tupla)