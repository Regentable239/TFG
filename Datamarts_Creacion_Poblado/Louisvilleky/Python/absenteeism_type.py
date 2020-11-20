import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Absenteeism_Type.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Absenteeism_Type_Name","Absenteeism_Type_id"
    tupla="INSERT INTO ABSENTEEISM_TYPE (Absenteeism_Type_Name,Absenteeism_Type_id) VALUES (" + lista[0] + "," + lista[1] + ");"
    print(tupla)