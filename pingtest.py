import csv
import os
from pathlib import Path
import platform    # For getting the operating system name
import subprocess  # For executing a shell command

home = str(Path.home())
path = os.path.join(home, "temp")
print("Working directory: " + path)
count = 0

##CHANGE THIS TO THE CSV FILE YOU WANT TO USE
in_path = "1607_Machines_jul29.csv"

#in_path = name of CSV, do not include entire path. Script autogenerates env in ~/temp





def ping(host):
    """
    Returns True if host (str) responds to a ping request.
    Remember that a host may not respond to a ping (ICMP) request even if the host name is valid.
    """

    # Option for the number of packets as a function of
    param = '-n' if platform.system().lower()=='windows' else '-c'

    # Building the command. Ex: "ping -c 1 google.com"
    command = ['ping', param, '1', host]

    return subprocess.call(command) == 0


with open(os.path.join(path, in_path), newline='', encoding="utf8") as csvfile:
    data = list(csv.reader(csvfile))


print(data)
raw_count = len(data)
return_list = []

for server in data:
    server_Name = str(server).strip("[']")
    response = (ping(server_Name))
    ##print("STRING STRING : " + str(response))
    if (response):
        return_list.append(server_Name + " ping success, host is up")
    else:
        return_list.append(server_Name + " NOT REACHABLE via THQ network")
    count += 1
for i in return_list:
    if "Not reachable" in i:
        print("!!! " + i)
    else:
        print(i)
print("\n" + "Hosts in csv: " + str(raw_count))
print("Hosts pinged: " + str(count))

out_path = os.path.join(path, "ping_test_1607.txt")

with open(out_path, "w") as txtfile:
    for line in return_list:
        txtfile.write("".join(line) + "\n")
        txtfile.write("\n" + "Hosts in csv: " + str(raw_count))
        txtfile.write("\n" + "Hosts pinged: " + str(count))

print("\ntxt file saved in: " + str(out_path))