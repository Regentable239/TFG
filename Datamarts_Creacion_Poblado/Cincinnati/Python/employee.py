import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Cincinnati/CSV/Employee.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Cincinnati;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Age_Range","Gender","Race","Employee_Surname","Employee_Name","Employee_id"
    tupla="INSERT INTO EMPLOYEE (Age_Range,Gender,Race,Employee_Surname,Employee_Name,Employee_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + ");"
    print(tupla)