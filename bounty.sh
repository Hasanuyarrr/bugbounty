#!/bin/bash

# Renk kodları
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m" # No Color

# Kullanım bilgisi
usage() {
    echo -e "${YELLOW}Kullanım: $0 -d <domain> [--proxy http://127.0.0.1:8080]${NC}"
    exit 1
}

# Değişkenler
PROXY=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d) DOMAIN="$2"; shift ;;
        --proxy) PROXY="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Domain belirtilmemişse hata ver
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}[X] Hata: Domain belirtilmedi.${NC}"
    usage
fi

# Çıktı dizini
OUTPUT_DIR="subdomain_enum/$DOMAIN"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/gf_results"

echo -e "${BLUE}[*] Subdomain keşfi başlatılıyor: $DOMAIN${NC}"

### **1. Subdomain Keşfi**
subfinder -d "$DOMAIN" -o "$OUTPUT_DIR/subfinder.txt"
assetfinder --subs-only "$DOMAIN" | anew "$OUTPUT_DIR/assetfinder.txt"
cat "$OUTPUT_DIR/"*.txt | anew "$OUTPUT_DIR/all_subdomains.txt"

echo -e "${YELLOW}[+] Subdomainler üzerindeki endpoint ve parametreler toplanıyor...${NC}"

### **2. Subdomainlere Ait URL ve Parametre Keşfi**
for sub in $(cat "$OUTPUT_DIR/all_subdomains.txt"); do
    echo -e "${YELLOW}[*] Tarama yapılıyor: $sub${NC}"
    
    echo "$sub" | gau | anew "$OUTPUT_DIR/urls.txt"
    echo "$sub" | waybackurls | anew "$OUTPUT_DIR/urls.txt"
    hakrawler -d 3 -subs -t 10 -timeout 5 -u | anew "$OUTPUT_DIR/hakrawler_urls.txt"
    gospider -S "$OUTPUT_DIR/urls.txt" -o "$OUTPUT_DIR/gospider_urls.txt"
    katana -u "$sub" -d 10 -o "$OUTPUT_DIR/katana_urls.txt"
done

### **3. URL'leri Temizleme ve Filtreleme**
echo -e "${YELLOW}[+] Tekrar eden URL'ler temizleniyor...${NC}"
cat "$OUTPUT_DIR/"*.txt | uro | anew "$OUTPUT_DIR/clean_urls.txt"

### **4. Aktif URL'leri Bulma**
echo -e "${YELLOW}[+] Canlı URL'ler filtreleniyor...${NC}"
httpx -l "$OUTPUT_DIR/clean_urls.txt" -o "$OUTPUT_DIR/active_urls.txt" -threads 200 -silent

### **5. GF ile Güvenlik Açığı İçeren URL'leri Ayrıştırma**
echo -e "${YELLOW}[+] GF ile güvenlik açığı olabilecek URL'ler filtreleniyor...${NC}"

declare -a patterns=("debug_logic" "idor" "img-traversal" "interestingEXT" "interestingparams" "interestingsubs" "jsvar" "lfi" "rce" "redirect" "sqli" "ssrf" "ssti" "xss")

for pattern in "${patterns[@]}"; do
    cat "$OUTPUT_DIR/active_urls.txt" | gf "$pattern" | anew "$OUTPUT_DIR/gf_results/${pattern}.txt"
done

### **6. Burp Suite Proxy Kullanımı (Opsiyonel)**
if [ ! -z "$PROXY" ]; then
    echo -e "${YELLOW}[+] Burp Suite Proxy kullanılarak HTTP istekleri gönderiliyor...${NC}"
    cat "$OUTPUT_DIR/active_urls.txt" | httpx -proxy "$PROXY" -o "$OUTPUT_DIR/burp_proxied_urls.txt"
fi

echo -e "${GREEN}[✓] Tüm işlemler tamamlandı! Sonuçlar '$OUTPUT_DIR' klasöründe.${NC}"

