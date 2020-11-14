

```bash
docker pull wernight/ngrok

docker run -itd \
    --name ngrok
    wernight/ngrok
    ngrok http 6789
```