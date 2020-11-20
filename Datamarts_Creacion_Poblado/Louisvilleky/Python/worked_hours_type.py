import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Worked_Hours_Type.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Date_Format_YYYY_MM_DD","Year","Quarter","Month","Day","Date_id"
    tupla="INSERT INTO WORKED_HOURS_TYPE (Description_Type_Worked_Hours,Code_Hours_Type,Name_Hours_type,Worked_Hours_Type_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + ");"
    print(tupla)