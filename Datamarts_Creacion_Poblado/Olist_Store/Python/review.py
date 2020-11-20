import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Olist_Store/CSV/reviews.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Olist_Store;")

for line in file:
    lista = list(line.replace("\n", "").split(";")) 
    # "Review_Code","Review_Comment_Title","Review_Comment_Message","Review_id"
    if not lista[1] and not lista[2]:
        tupla="INSERT INTO REVIEW (Review_Code,Review_id) VALUES (" + lista[0] + "," + lista[3] + ");"
    elif not lista[1]:
        tupla="INSERT INTO REVIEW (Review_Code,Review_Comment_Message,Review_id) VALUES (" + lista[0] + "," + lista[2] + "," + lista[3] + ");"
    elif not lista[2]:
        tupla="INSERT INTO REVIEW (Review_Code,Review_Comment_Title,Review_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[3] + ");"
    else:
        tupla="INSERT INTO REVIEW (Review_Code,Review_Comment_Title,Review_Comment_Message,Review_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + ");"
    print(tupla)