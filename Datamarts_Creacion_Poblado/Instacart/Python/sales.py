import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/DATA/instacart_2017_05_01/sales.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Instacart;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    tupla="INSERT INTO SALES (O_Order_ID,P_Product_ID,add_to_cart_order,suggested_sale,C_Customer_ID,order_number, W_Weekday_ID,H_Hour_ID,A_Aisle_ID,D_Department_ID) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + "," + lista[6] + "," + lista[7] + "," + lista[8] + "," + lista[9] + ");"
    print(tupla)