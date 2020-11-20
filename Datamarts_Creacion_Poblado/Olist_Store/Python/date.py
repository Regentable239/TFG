import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/date.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Date_Format_YYYYMMDD","Year","Quarter","Month","Week_of_Year","Day_of_Month","what_Weekday_num","what_Weekday_name","is_Weekend","is_Holiday","Date_id"
    tupla="INSERT INTO DATE (Date_Format_YYYYMMDD,Year,Quarter,Month,Week_of_Year,Day_of_Month,Weekday_Num,Weekday_Name,is_Weekend,is_Holiday,Date_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + "," + lista[6] + "," + lista[7]  + "," + lista[8]  + "," + lista[9] + "," + lista[10] + ");"
    print(tupla)