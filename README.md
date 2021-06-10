# OverView
This project helps in adding multiple vCloud edge firewall rules using the terraform. It is time consuming and error prone when you have to add many firewall rules on Edge gateway manually. This script helps in applying multiple firewall rules from CSV file. 

# Prerequisites
1. Install Terraform


# How to use?
Once the project is cloned to your local machine, follow the steps below.
1. Add the firewall rules in rules.csv file in mentioned format.

  | sequence | Name    | source_addresses | destination_addresses     | destination_ports | protocols |
|----------|---------|------------------|---------------------------|-------------------|-----------|
| 1        | Https   | any              | internal                  | 443               | TCP       |
| 2        | Http    | any              | internal                  | 80                | TCP       |
| 3        | SSH     | any              | internal                  | 22                | TCP       |
| 4        | NTP1    | internal         | 192.61.192.3-192.61.192.4 | 123               | UDP       |
| 5        | Proxy   | internal         | 192.61.192.2              | 8080              | TCP       |
| 6        | DNS     | internal         | 192.61.192.2              | 53                | UDP       |
| 7        | DNS-TCP | internal         | 192.61.192.2              | 53                | TCP       |
3. When specifiying the firewall rules make sure there are no extra spaces in any of the cells.
4. Terrafrom module does not accept the multiple IP addresses or ports in single rule in the csv file for example below rules will result in an error :

| sequence | Name    | source_addresses | destination_addresses     | destination_ports | protocols |
|----------|---------|------------------|---------------------------|-------------------|-----------|
| 1        | Https   | any              | internal                  | 443,80            | TCP       |

 or 
| sequence | Name    | source_addresses | destination_addresses     | destination_ports | protocols |
|----------|---------|------------------|---------------------------|-------------------|-----------|
| 1        | Https   | any              | 192.168.0.1, 192.168.0.10 | 443               | TCP       |

5. But you can sepcifiy multiple IP addresses or ports if they are in a sequence :

| sequence | Name    | source_addresses | destination_addresses     | destination_ports | protocols |
|----------|---------|------------------|---------------------------|-------------------|-----------|
| 1        | Https   | any              | internal                  | 443-500           | TCP       |

 or 
| sequence | Name    | source_addresses | destination_addresses     | destination_ports | protocols |
|----------|---------|------------------|---------------------------|-------------------|-----------|
| 1        | Https   | any              | 192.168.0.1-192.168.0.10   | 443               | TCP       |

5. It is expecting the rules.csv file in the same diretly where other files for this porject are. You can change that if needed.
6. Update the terrafrom.tfvars with the variables values for your enviroment.
7. Then you can simply run the "terrafrom plan" and "terrafrom apply" to apply the firewalls rules from the rules.csv to edge gateway in vCloud Directory.

# References
Documentation for Terraform VCD provider : https://registry.terraform.io/providers/vmware/vcd/latest/docs/resources/nsxv_firewall_rule
