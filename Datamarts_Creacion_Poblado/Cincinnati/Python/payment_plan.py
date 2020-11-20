import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Cincinnati/CSV/Payment_Plan.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Cincinnati;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Pay_Group","Salary_Plan","Paymant_Plan_Id"
    tupla="INSERT INTO PAYMENT_PLAN_EMPLOYEE (Pay_Group,Salary_Plan,Payment_Plan_Id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + ");"
    print(tupla)