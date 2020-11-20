import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Turnover_Reason.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Description_Reason","Description_Leave_Type","Turnover_Reason_id"
    tupla="INSERT INTO TURNOVER_REASON (Description_Reason,Description_Leave_Type,Turnover_Reason_id) VALUES (" + lista[0] + "," + lista[1] + "," +  lista[2] + ");"
    print(tupla)