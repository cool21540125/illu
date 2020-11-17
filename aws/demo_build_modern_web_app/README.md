
- [建立現代 Web 應用程式](https://aws.amazon.com/tw/getting-started/hands-on/build-modern-app-fargate-lambda-dynamodb-python/)

![aws架構圖](../../img/architecture-diagram-AWS-Developer-Center_mythical-mysfits-application-architecture.png)


1. 用 s3 建立 static web
2. 用 aws fargate 部署 Container(API 後端 microservice), web serverr 託管 app 邏輯
3. 資料存到 DynamoDb 內的 NoSQL
4. 藉由 API Gateway && Amazon Cognito, 讓使用者可 register, authorize, authenticate
5. 藉由 AWS Lambda && Amazon Kinesis Firehose, 分析使用者行為
