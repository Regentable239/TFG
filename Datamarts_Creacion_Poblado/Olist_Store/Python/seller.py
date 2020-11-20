import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/seller.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Seller_Code","Seller_Zip_Code_Prefix","Seller_City","Seller_State","Seller_id"
    tupla="INSERT INTO SELLER (Seller_Code,Seller_Zip_Code_Prefix,Seller_City,Seller_State,Seller_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + ");"
    print(tupla)