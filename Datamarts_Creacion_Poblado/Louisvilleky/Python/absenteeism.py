import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Absenteeism.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Total_Absenteeism_Hours","Total_Employees","Total_Aval_Hours","Payment_Date","Departament_id","Absenteeism_Type_id"
    tupla="INSERT INTO ABSENTEEISM (Total_Absenteeism_Hours,Total_Employees,Total_Aval_Hours,Payment_Date,Departament_id,Absenteeism_Type_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + ");"
    print(tupla)