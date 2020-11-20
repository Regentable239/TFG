import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/DATA/instacart_2017_05_01/product_edit.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Instacart;")

for line in file:
    lista = list(line.replace("\n", "").split(";")) 
    #tupla="INSERT INTO PRODUCT (Product_ID, Product_Name) VALUES (" + lista[0] + ",\"" + lista[1] + "\");"
    tupla="UPDATE PRODUCT SET Product_Name= \"" + lista[1].replace('"', '').replace(',', '.') + "\" WHERE Product_ID=" + lista[0] + ";"
    print(tupla)