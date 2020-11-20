import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/Product_sale.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Order_id","Order_Item","Price","Freight_Value","Customer_id","Seller_id","Product_id","Date_Sale_id","Hour_Sale_id"
    tupla="INSERT INTO PRODUCT_SALE (Order_id,Order_Item,Price,Freight_Value,Customer_id,Seller_id,Product_id,Date_Sale_id,Hour_Sale_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + "," + lista[6] + "," + lista[7]  + "," + lista[8] + ");"
    print(tupla)