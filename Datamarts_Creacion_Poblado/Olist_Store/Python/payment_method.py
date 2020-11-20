import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/payment_Method.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Payment_Type","Payment_Installments","Payment_id"
    tupla="INSERT INTO PAYMENT_METHOD (Payment_Type,Payment_Installments,Payment_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + ");"
    print(tupla)