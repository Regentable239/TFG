import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Cincinnati/CSV/Employee_Salary.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Cincinnati;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Standard_Hours","Type_Shift_Full_Or_Part_Time","Rank_Grade_Employee","Annual_RT","Employee_id","Departament_id","Job_id","Paymant_Plan_Id","Date_Entry_DT","Hire_Date"
    tupla="INSERT INTO EMPLOYEE_SALARY (Standard_Hours,Type_Shift_Full_Or_Part_Time,Rank_Grade_Employee,Annual_RT,Employee_id,Departament_id,Job_id,Payment_Plan_id,Date_Entry_DT,Hire_Date) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + "," + lista[6] + "," + lista[7] + "," + lista[8] + "," + lista[9] + ");"
    print(tupla)