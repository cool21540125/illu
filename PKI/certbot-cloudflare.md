# 

- [certbot-dns-cloudflare’s Documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)

- `dns_cloudflare` plugin 自動完成 `dns-01` challenge (透過 DNS 驗證)

所需參數:
- `--dns-cloudflare-credentials`         : credentials INI file
- `--dns-cloudflare-propagation-seconds` : 等待 DNS 同步, 後續開始 ACME Challenge 的等待時間(預設10秒)


Cloudflare API Token:
- 傳統的 `Global API Key` 可以進行 full access 的操作
- 新一代的 token: 可作權限範圍設定, 需要有 `Zone:DNS:Edit`. (但須 `cloudflare` python module >= 2.3.1)


```bash
### 使用範例
certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  -d example.com
```

## certbot 3rd plugins

The Certbot client supports 2 types of plugins for obtaining and installing certificates: 
- authenticators
    - 使用 `certbot certonly` 來作證書申請. 
    - 預設會將證書放到 `/etc/letsencrypt`
    - 可以一次生成一個 multiple domain in 1 cert
    - 若要生成多個 one by one cert, 則需要進行多次操作 certbot
- installers
    - 安裝憑證到 Server && 幫忙組態配置

如果把上述兩步驟和再一起, 其實就是 `certbot run`(也就是預設)
