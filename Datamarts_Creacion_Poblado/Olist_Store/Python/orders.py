import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/Order.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

columna = ["Order_id","Estimated_Delivery_Date","Estimated_Delivery_Hour","Delivered_Customer_Date","Delivered_Customer_Hour","Delivered_Carrier_Date","Delivered_Carrier_Hour","Approved_Payment_Date","Approved_Payment_Hour","Purchase_Timestamp_Date","Purchase_Timestamp_Hour","Customer_id","Total_Price_Order","Num_Products","Amount_Voucher","Payment_id"]
for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # Las columnas que son vacias porque el envio esta en camino no se añaden
    tupla="INSERT INTO ORDERS ("
    aux=") VALUES ("
    for i in range(len(columna)):
        if lista[i]:
            tupla=tupla+columna[i]+","
            aux=aux+lista[i]+","
    tupla=tupla[:-1]+aux[:-1]+");"
    print(tupla)