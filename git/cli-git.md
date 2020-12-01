# 常用指令備註

```bash
### ed25519 (比 rsa 更有效率 && 安全)
# https://docs.gitlab.com/ee/ssh/README.html#ed25519-ssh-keys
$# ssh-keygen -t ed25519 -C "tony@tonynb"
# 產生 id_ed25519 && id_ed25519.pub


### 將來可用 git tree 來漂亮的看提交紀錄
git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit"


### 設定追蹤遠端分支
BRANCH=dev
git branch --set-upstream-to=origin/${BRANCH} ${BRANCH}


### 手動推送到遠端分支
BRANCH=feature
git push --set-upstream origin ${BRANCH}


### 改變追蹤 URL
REPOSITORY=origin
GIT_URL=git@github.com:cool21540125/documentation-notes.git
git remote set-url ${REPOSITORY} ${GIT_URL}


### push tag
TAG_NAME=1.0.0
git push origin ${TAG_NAME}
```