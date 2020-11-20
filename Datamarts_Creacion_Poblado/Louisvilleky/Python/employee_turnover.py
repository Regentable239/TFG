import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Employee_Turnover.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Date_End_Worked","Departament_id","Employee_Profile_id","Turnover_Reason_id","Employee_Turnover_id"
    tupla="INSERT INTO EMPLOYEE_TURNOVER (Date_End_Worked,Departament_id,Employee_Profile_id,Turnover_Reason_id,Employee_Turnover_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + ");"
    print(tupla)