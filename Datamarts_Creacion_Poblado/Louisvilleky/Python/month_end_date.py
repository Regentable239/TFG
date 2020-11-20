import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Month_End_Date.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Date_Format_YYYYMMDD","Year","Quarter","Month","Day","Date_id"
    tupla="INSERT INTO MONTH_END_DATE (Date_Format_YYYYMMDD,Year,Quarter,Month,Day,Date_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + ");"
    print(tupla)