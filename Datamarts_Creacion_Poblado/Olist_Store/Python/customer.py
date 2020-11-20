import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/Customer.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Customer_Code","Customer_Unique_Code","Customer_Zip_Code_Prefix","Customer_City","Customer_State","Customer_id"
    tupla="INSERT INTO CUSTOMER (Customer_Code,Customer_Unique_Code,Customer_Zip_Code_Prefix,Customer_City,Customer_State,Customer_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + ");"
    print(tupla)