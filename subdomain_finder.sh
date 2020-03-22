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
 echo -e " \033[0;31m Syntax : ./subfind.sh domain.com \033[0m"
else
 echo "Enumerating subdomain from threatcrowd....." 
 curl -s https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1 | jq .subdomains | cut -d '"' -f2 | tr -d '[' | tr -d ']' > sub.txt
 echo -e "\033[0;31mSubdomains Found:\033[0m"
 cat sub.txt
 

 echo "Enumerating subdomain from hackertarget...."
 curl -s https://api.hackertarget.com/hostsearch/?q=$1 | cut -d ',' -f1 >> sub.txt
 echo -e "\033[0;31mSubdomains Found:\033[0m"
 cat sub.txt

 echo "Enumerating from cert.sh...."
 curl -s https://crt.sh/?q=%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >> sub.txt
 echo -e "\033[0;31mSubdomains Found:\033[0m"
 cat sub.txt

 echo "Enumerating from certspotter...."
 curl -s https://certspotter.com/api/v0/certs?domain=google.com | grep  -o '\[\".*\"\]' | cut -d '"' -f2 >> sub.txt
 echo -e "\033[0;31mSubdomains Found:\033[0m"
 cat sub.txt

 echo " " 
 echo " "
 echo " "
 echo -e "\033[0;31m Sorting and taking Unique subdomains.....\033[0m"
 cat sub.txt | sort -u | uniq -u >> final.txt
 echo " "
 echo " "
 echo " "
 echo -e "\033[0;31m Found [ $(wc -l final.txt) ] unique Subdomains"
 echo -e "\033[0;31m Written to file : \033[0m final.txt" 
fi
