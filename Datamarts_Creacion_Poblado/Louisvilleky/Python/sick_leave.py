import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Sick_Leave.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Date_Format_YYYY_MM_DD","Year","Quarter","Month","Day","Date_id"
    tupla="INSERT INTO SICK_LEAVE (High_Consumer_Employee,Total_Employees,Payment_Date,Departament_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + ");"
    print(tupla)