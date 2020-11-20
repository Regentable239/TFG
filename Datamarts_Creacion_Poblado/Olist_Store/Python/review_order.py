import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/review_order.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Order_id","Score","Review_id","Customer_id","Date_Permit_Review","Hour_Permit_Review","Date_Answer_Review","Hour_Answer_Review"
    tupla="INSERT INTO REVIEW_ORDER (Order_id,Score,Review_id,Customer_id,Date_Permit_Review,Hour_Permit_Review,Date_Answer_Review,Hour_Answer_Review) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + "," + lista[6] + "," + lista[7] + ");"
    print(tupla)