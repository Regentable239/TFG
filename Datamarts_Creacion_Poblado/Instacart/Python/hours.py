import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/DATA/instacart_2017_05_01/hours.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Instacart;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    tupla="INSERT INTO HOUR (Hour_ID, Format_HHMM) VALUES (" + lista[0] + ",\"" + lista[1] + "\");"
    print(tupla)