# aws CLI

- 2020/04/18
- [設定 AWS CLI](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-chap-configure.html)

```sh
### 註冊登入
$ aws configure
# id && secret key 去註冊 IAM 最後就看得到了 
#     IAM > 您的安全登入資料 > 存取金鑰 (存取金鑰 ID 和私密存取金鑰)
# Default Region: 
#     ex: 「ap-northeast-1」 為 「亞太區域 (東京)」
# 分別輸入 ID, token, region, format 之後
# 便會把身份資訊寫入到 ~/.aws/credentials
# 之後便可開始使用 aws cli

$ aws configure
AWS Access Key ID [****************4628]: 
AWS Secret Access Key [****************WORQ]: 
Default region name [ap-northeast-1]: 
Default output format [json]: 
```


# Service

- AWS Cloud9:                        線上 IDE
- AWS Fargate:                       同 AWS Lambda. 適合做 **長期執行程序 (ex: API backend)**, 本身運行在 ECS 內(ECS 的部署選項)
- AWS Lambda:                        Serverless. 適合做 **即時回應資料變更、系統狀態變化或使用者操作的資料驅動型應用程式**
- AWS CloudFormation:                可用 json 或 yaml, 來定義雲服務架構. 基礎設施視為程式碼, 參考: `aws > examples > core.yml`
- AWS Elastic Container Service, ECS: 用來部署 Container 而無須管理 Cluster 或 Server