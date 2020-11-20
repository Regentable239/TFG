import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/Total_Hour_Worked.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Amount_Hours","Amount_Dollars","Payment_Date","Departament_id","Worked_Hours_Type_id"
    tupla="INSERT INTO TOTAL_HOUR_WORKED (Amount_Hours,Amount_Dollars,Payment_Date,Departament_id,Worked_Hours_Type) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + ");"
    print(tupla)