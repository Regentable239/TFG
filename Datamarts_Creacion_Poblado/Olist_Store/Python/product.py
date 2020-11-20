import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/Product.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Product_Code","Category_Name_PORT","Product_Name_Lenght","Product_Description_Lenght","Product_Photos_Qty","Product_Weight_g","Product_Length_cm","Product_Height_cm","Product_Width_cm","Category_Name_ENG","Product_id"
    tupla="INSERT INTO PRODUCT (Product_Code,Category_Name_PORT,Product_Name_Lenght,Product_Description_Lenght,Product_Photos_Qty,Product_Weight_g,Product_Length_cm,Product_Height_cm,Product_Width_cm,Category_Name_ENG,Product_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + "," + lista[6] + "," + lista[7]  + "," + lista[8]  + "," + lista[9] + "," + lista[10] + ");"
    print(tupla)