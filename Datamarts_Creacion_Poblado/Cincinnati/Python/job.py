import re

file = open("/mnt/c/Users/Grego/Desktop/TFG/FICHEROS/Python/Cincinnati/CSV/Job.csv", "r")
first = file.readline() # Se elimina la cabecera del csv

print("USE Cincinnati;")

for line in file:
    lista = list(line.replace("\n", "").split(",")) 
    # "Job_Code","Job_Name","Job_ABBRV","Job_id"
    tupla="INSERT INTO JOB (Job_Code,Job_Name,Job_ABBRV,Job_id) VALUES (" + lista[0] + "," + lista[1] + "," + lista[2] + "," + lista[3] + ");"
    print(tupla)