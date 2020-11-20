import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Cincinnati/CSV/Departament.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Cincinnati;")

for line in file:
    lista = list(line.replace("\n", "").split(";")) 
    # "Departament_Code","Departament_Name","Departament_ABBRV","Departament_id"
    tupla="INSERT INTO DEPARTAMENT (Departament_Code,Departament_Name,Departament_ABBRV,Departament_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + ");"
    print(tupla)