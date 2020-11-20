import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/departament.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Departament_Name","Departament_id"
    tupla="INSERT INTO DEPARTAMENT (Departament_Name,Departament_id) VALUES (" + lista[0] + "," + lista[1] + ");"
    print(tupla)