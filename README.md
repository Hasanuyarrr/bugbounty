
# 🕵️‍♂️ Subdomain & Endpoint Recon Script
Bu bash scripti, belirli bir domain için subdomain keşfi, endpoint toplama, aktif URL'leri belirleme ve potansiyel güvenlik açıklarını filtreleme amacıyla geliştirilmiştir. Ayrıca, Burp Suite proxy desteği ile test süreçlerinizi kolaylaştırır.
Tarama 1 saatten uzun sürebilir bu web sitesinin büyüklüğüne bağlıdır.

## 🔥 Özellikler
✅ Subdomain keşfi: subfinder, assetfinder  
✅ Bulunan subdomainlerde endpoint & parametre tarama: gau, waybackurls, gospider, hakrawler, katana  
✅ URL temizleme & aktif test: uro, httpx  
✅ Güvenlik açığı analizi: gf (debug_logic, idor, xss, sqli, rce vb.)  
✅ Burp Suite proxy desteği  

## 📦 Gereksinimler & Kurulum

### 1️⃣ Gerekli Araçları Yükleme
Bu scriptin çalışması için aşağıdaki araçların yüklü olması gerekmektedir. Eğer eksikse, aşağıdaki komutları çalıştırarak yükleyebilirsiniz.

#### 🔹 Go Tabanlı Araçları Kurma
```bash
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/jaeles-project/gospider@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/gf@latest && cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf
go install github.com/hahwul/dalfox/v2@latest
pip3 install uro
```

### 2️⃣ Script’i İndirme ve Çalıştırma
```bash
git clone https://github.com/Hasanuyarrr/bugbounty.git
cd bugbounty
sudo mv bounty.sh /usr/local/bin/bounty
chmod +x bounty
bounty -d example.com --proxy http://127.0.0.1:8080
```


## 📂 Çıktılar (subdomain_enum/example.com/ Klasöründe)
```bash
subdomain_enum/example.com/
├── subfinder.txt               # Subfinder ile bulunan subdomainler
├── assetfinder.txt             # Assetfinder ile bulunan subdomainler
├── all_subdomains.txt          # Birleştirilmiş subdomainler
├── urls.txt                    # Bulunan tüm URL’ler
├── clean_urls.txt              # Temizlenmiş URL’ler
├── active_urls.txt             # Canlı URL’ler
├── gf_results/                 # GF ile bulunan güvenlik açıkları
│   ├── debug_logic.txt
│   ├── idor.txt
│   ├── img-traversal.txt
│   ├── interestingEXT.txt
│   ├── interestingparams.txt
│   ├── interestingsubs.txt
│   ├── jsvar.txt
│   ├── lfi.txt
│   ├── rce.txt
│   ├── redirect.txt
│   ├── sqli.txt
│   ├── ssrf.txt
│   ├── ssti.txt
│   ├── xss.txt
├── burp_proxied_urls.txt       # Burp Suite Proxy üzerinden istek yapılan URL'ler



