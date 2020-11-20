import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Louisvilleky/CSV/OSHA.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Louisvilleky;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "OSHA_id","Payment_Date","Departament_id","OSHA_Type_id","numIncidentsLeadingToLostDays","numIncidentsLeadingToRestrictedDays"
    tupla="INSERT INTO OSHA_ACCIDENTS (OSHA_id,Payment_Date,Departament_id,OSHA_Type_id,numIncidentsLeadingToLostDays,numIncidentsLeadingToRestrictedDays) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + "," + lista[4] + "," + lista[5] + ");"
    print(tupla)