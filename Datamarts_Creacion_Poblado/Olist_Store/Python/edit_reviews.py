import re

file = open("olist_order_reviews_dataset.csv", "r")
first = file.readline()

for line in file:
    m = re.match('^(\"*\w{32}\"*),(.*)$',line)
    if m:
        t = re.match('^\"*(\w{32})\"*,\"*(\w{32})\"*,(\d{1}),\"*(.*)\"*,\"*(.*)\"*,(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})$',line)
        if t:
            print(t.group(1)+";"+t.group(2)+";"+t.group(3)+";"+t.group(4).replace(';',',')+";"+t.group(5).replace(';',',')+";"+t.group(6)+";"+t.group(7))
        else:
            p=line.strip('\n') + " " + file.readline()
            while(1):
                t = re.match('^\"*(\w{32})\"*,\"*(\w{32})\"*,(\d{1}),\"*(.*)\"*,\"*(.*)\"*,(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})$',p)
                if t:
                    print(t.group(1)+";"+t.group(2)+";"+t.group(3)+";"+t.group(4).replace(';',',')+";"+t.group(5).replace(';',',')+";"+t.group(6)+";"+t.group(7))
                    break
                else:
                    p = p.strip('\n') + " " + file.readline()