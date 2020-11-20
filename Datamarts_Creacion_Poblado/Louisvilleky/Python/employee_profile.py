import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Employee_Profile.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Type_Employee","Age_Range","Ethnic_Group","Gender","Years_Worked_Range","Employee_Profile_id"
    tupla="INSERT INTO EMPLOYEE_PROFILE (Type_Employee,Age_Range,Ethnic_Group,Gender,Years_Worked_Range,Employee_Profile_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + ");"
    print(tupla)