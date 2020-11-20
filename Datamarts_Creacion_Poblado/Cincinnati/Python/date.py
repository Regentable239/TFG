import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Cincinnati/CSV/Date.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Cincinnati;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Month","Day","Year","Date_Format_YYYYMMDD","Date_id"
    tupla="INSERT INTO DATE (Month,Day,Year,Date_Format_YYYYMMDD,Date_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + ");"
    print(tupla)