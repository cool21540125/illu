# Install drone-agent

- 2020/04/02
- [用 10 分鐘安裝好 Drone 搭配 GitLab](https://blog.wu-boy.com/2019/08/install-drone-with-gitlab-in-10-minutes/)

使用 Public GitLab

1. 前往 GitLab > Settings > Applcations, 建立一組 Applications
    - Name 隨便打
    - Redirect URI 暫填 `http://localhost/login`
    - 權限給 `api`, `read_user`
2. 假設 Host: `https://example.tonychoucc.com`
3. 回到 GitLab, 修改剛剛填的 Redirect URI:
    - `http://localhost/login` -> `https://example.tonychoucc.com/login` (Drone 1.0, 結尾一定要是 `/login`)
    - COPY **Application ID**  -> DRONE_GITLAB_CLIENT_ID
    - COPY **Secret**          -> DRONE_GITLAB_CLIENT_SECRET
    - COPY **Callback URL**    -> DRONE_SERVER_HOST
4. 填寫 `.env`
5. `docker-compose up -d`
6. Browser -> **https://example.tonychoucc.com/login** 看到 Authorization 的頁面就算成功了

```ini
DRONE_SERVER_HOST=example.tonychoucc.com
DRONE_SERVER_PROTO=https
DRONE_RPC_SECRET=  # 用來和 Drone Agent 溝通用
DRONE_GITLAB_CLIENT_ID=gb478bfr76egh5345hi129q30osahgbeamzbvjashrfbvyqg1btyuhgiugthujuu
DRONE_GITLAB_CLIENT_SECRET=bwug5n8sbn5hnarqaqpa28tg7hbsonbvzdfrg5bngkvhbkrgb8zr8765568arg42
# 上面的 id, secret 都是假的, 請不要白癡到拿這個去用....
```                        
