#!/bin/bash
rm -rf sub.txt
rm -rf final.txt
echo -e """
\033[0;34m
  ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ 
||O |||p |||e |||n |||       |||S |||u |||b |||d |||o |||m |||a |||i |||n |||       |||F |||i |||n |||d |||e |||r ||
||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|

                                         Coded by: ZyperX && MassCan
                                       [Tool Still Under Development]
"""
echo " "
echo " " 
if [ $# -lt 1 ];then
 echo -e " \033[0;31m Syntax : subfinder domain.com \033[0m"
else
 echo "[-]Enumerating subdomain from threatcrowd....." 
 curl -s https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1 | jq .subdomains | cut -d '"' -f2 | tr -d '[' | tr -d ']' > sub.txt
 echo -e "\033[0;31m[+]Subdomains Found:\033[0m"
 cat sub.txt
 

 echo -e "\e[34m[-]Enumerating subdomain from hackertarget....\e[0m"
 curl -s https://api.hackertarget.com/hostsearch/?q=$1 | cut -d ',' -f1 >> sub.txt
 echo -e "\033[0;31m[+]Subdomains Found:\033[0m"
 cat sub.txt

 echo -e "\e[34m[-]Enumerating from cert.sh....\e[0m"
 curl -s https://crt.sh/?q=%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >> sub.txt
 echo -e "\033[0;31m[+]Subdomains Found:\033[0m"
 cat sub.txt

 echo -e "\e[34m[-]Enumerating from certspotter....\e[0m"
 curl -s https://certspotter.com/api/v0/certs?domain=$1 | grep  -o '\[\".*\"\]' | cut -d '"' -f2 >> sub.txt
 echo -e "\033[0;31m[+]Subdomains Found:\033[0m"
 cat sub.txt

 echo -e "\e[34m[-]Enumerating from bufferover....\e[0m"
 curl -s "https://dns.bufferover.run/dns?q=."$1"" | grep -v ':' | tr -d "]}{" | cut -d "," -f2 | tr -d '"'| grep -v -E ".*?.gz"|sed '/^$/d' >> sub.txt
 echo -e "\033[0;31m[+]Subdomains Found:\033[0m"
 cat sub.txt

 echo -e "\e[34m[-]Bruteforcing using Sublist3r....\e[0m"
 sublist3r -d $1 -o tmp
 cat tmp >> sub.txt
 rm -rf tmp
 echo -e "\033[0;31m[+]Subdomains Found:\033[0m"
 cat sub.txt 

 echo " " 
 echo " "
 echo " "
 echo -e "\033[0;31m[-]Sorting and taking Unique subdomains.....\033[0m"
 cat sub.txt | sort | uniq  >> final.txt
 echo " "
 echo " "
 echo " "
 echo -e "\033[0;31m[+]Found [ $(wc -l final.txt) ] unique Subdomains"
 echo -e "\033[0;31m[+] Written to file : \033[0m final.txt" 
 echo  "[-]Deleting temporary files...."
 rm -rf sub.txt
 
 echo -e "\033[0;34m[-]Running http probe...........................\033[0m"
 cat final.txt | httprobe > $1.txt
 cat $1.txt
 echo "[+]Written successfully in "$1.txt""

 echo -e "\033[0;34m[-]Running Aquatone...........................\033[0m"
 cat final.txt | aquatone -scan-timeout 500 ports -xlarge -screenshot-timeout 5
 cat aquatone_urls.txt >> $1.txt
 rm -rf aquatone_report.html  aquatone_session.json aquatone_urls.txt
 cat $1.txt | cut -d "/" -f3|  sort | uniq |
 echo "[+]Written successfully in "$1.txt""
 
 echo -e "[+]Total Alive subdomains found :\e[31m$(wc -l "$1".txt|cut -d " " -f1)"

fi
