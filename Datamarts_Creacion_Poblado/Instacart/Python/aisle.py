import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/DATA/instacart_2017_05_01/aisles.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Instacart;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    tupla="INSERT INTO AISLE (Aisle_ID, Aisle_Name) VALUES (" + lista[0] + ",\'" + lista[1] + "\');"
    print(tupla)