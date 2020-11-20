import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/hour.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Hour_Format_HHMMSS","Hour","Minute","Second","Hour_id"
    tupla="INSERT INTO HOUR (Hour_Format_HHMMSS,Hour,Minute,Second,Hour_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + ");"
    print(tupla)