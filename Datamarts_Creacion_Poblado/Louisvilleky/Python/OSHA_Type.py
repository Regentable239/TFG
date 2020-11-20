import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/OSHA_Type.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(";")) 
    # "OSHA_Description","OSHA_Type_id"
    tupla="INSERT INTO OSHA_TYPE (OSHA_Description,OSHA_Type_id) VALUES (" + lista[0] + "," + lista[1] + ");"
    print(tupla)