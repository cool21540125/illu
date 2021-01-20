Dockerfile 那些該死的小細節


Dockerfile 內部的像是 `RUN`, `CMD`, `ENV`, `FROM`, ..., 都稱之為 instruction



#### [RUN](https://docs.docker.com/engine/reference/builder/#run)

RUN 用在 Image 的 Build time (用來 Commit Intermediate Layer), 於 Container runtime 並不會執行

RUN 有兩種格式: 

- *exec form*: `RUN ["executable", "param1", "param2"]`
    - 並沒有 shell 的環境, 所以不能直接讀取環境變數(只能手動實作)
        - 存取環境變數, 是由 shell 所處理
        - ex: `RUN ["/bin/sh", "-c", "echo $HOME"]`
    - 此會被轉譯成 JSON array, 因此必須使用 "", 而非 ''
        - 若轉譯失敗, 會被視為 *shell form*
        - 尤其是在 win, 關於路徑, 要留意路徑轉譯的問題
- *shell form*: `RUN <command>`
    - 此命令會在一個 shell 中執行
        - 預設的 shell 為 `/bin/sh -c`(Linux) 或 `cmd /S /C`(Win)
        - 存取環境變數, 是由 docker 所處理

------

關於 `RUN xxx --no-cache`

依照 Docker Image, 每一個指令都會創建一個 Intermediate Layer(或稱之為 cache)

每個 Layers 之間都是獨立的, 但是 RUN 例外

在此若要讓此 RUN 獨立出去(不要他影響後續 Layer), 則加上 `--no-cache`

此外, 可透過 `ADD` 及 `COPY`, 來讓 `RUN` 產生出來的 cache 無效


#### [CMD](https://docs.docker.com/engine/reference/builder/#cmd)

CMD 用於 Container runtime 的預設動作, 於 Image Build time 並不會執行

- 一個 Dockerfile 裡面只能有一個有效的 `CMD`
    - 若有多個, 最後一個才有效
- **`CMD` 的主要目的是, 為 執行容器, 提供預設動作**
    - `CMD` 的動作, 可以使用一個 executable
    - 也可省略, 並使用 `ENTRYPOINT` 來代替

有 2 種玩法:

- *exec form*: `CMD ["xxx", "xxx"]`
    - 建議用此格式, 可與 `ENTRYPOINT`(也須為 *exec form*) 搭配使用
    - 不會以 `/bin/sh -c` ˋ執行. 因此無法直接讀取 環境變數. 只能自行實作:
        - ex: `CMD ["/bin/sh", "-c", "echo $HOME"]`
    - 又可分為 2 種用法:
        - `CMD ["executable","param1","param2"]`
        - `CMD ["param1","param2"]`
            - 把 CMD 提供的 params, 作為 `ENTRYPOINT` 的預設參數
            - 前提條件是, ENTRYPOINT 也是使用 *exec form*
- *shell form*: `CMD command param1 param2`
    - 預設以 `/bin/sh -c` 執行. docker 直接處理 shell, 因此可 直接取得環境變數 當作參數傳入
    - 此形式將無法搭配 `ENTRYPOINT`

#### [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)

- [Dockerfile中的ENTRYPOINT](https://medium.com/@xyz030206/dockerfile-%E4%B8%AD%E7%9A%84-entrypoint-9653c3b2d2f8)
- [Running Custom Scripts In Docker With Arguments – ENTRYPOINT Vs CMD](https://devopscube.com/run-scripts-docker-arguments/)

用來定義 Container 運行起來的時候, 用來 run 的 executable

- 可使用 `docker run --entrypoint` 來覆寫 `ENTRYPOINT`
- 若有多個 `ENTRYPOINT`, 僅最後一個有效

有兩種玩法:
- *exec form*: `ENTRYPOINT ["executable", "param1", "param2"]`
    - 建議用此格式, 可與 `CMD`(也須為 *exec form*) 搭配使用
    - 不會以 `/bin/sh -c` ˋ執行. 因此無法直接讀取 環境變數. 只能自行實作:
        - ex: `ENTRYPOINT ["/bin/sh", "-c", "echo $HOME"]`
    - `docker run <image> -d`, 來將後續做為參數, 此將採用 *exec form*, 用來覆寫 `CMD`
- *shell form*: `ENTRYPOINT command param1 param2`  ((底下讀的不是很懂, 因此可能有錯))
    - 預設以 `/bin/sh -c` 執行. docker 直接處理 shell, 因此可 直接取得環境變數 當作參數傳入
    - 此形式將無法搭配 `CMD`, 且也無法藉由 `docker run` 的方式來傳遞參數.
    - 缺點: `ENTRYPOINT` 將會作為 `/bin/sh -c` 的子命令來啟動, 且不會傳遞 Signals.
        - 也就是說, 這個 executable 將不會是 Container 裡面的 **PID 1**, 且無法收到 Unix Signals.
        - 因此, 無法藉由 `docker stop <container>` 來接收到 SIGTERM 的訊號

```dockerfile
FROM centos:7
ENTRYPOINT ["curl"]
CMD ["-I", "https://google.com"]
```

來試試看吧

```sh
docker build -t demo .

docker run --rm demo
# 預設向 google.com 發送請球, 擷取 header

docker run --rm demo -v https://tw.yahoo.com/
# 改變預設, 向 tw.yahoo.com 發送請求, 取得詳細資料
```


#### [ADD](https://docs.docker.com/engine/reference/builder/#add)

src 可使用 URL, 參考下面用法:

```dockerfile
FROM scratch
ADD https://github.com/CentOS/sig-cloud-instance-images/raw/b2d195220e1c5b181427c3172829c23ab9cd27eb/docker/centos-7-x86_64-docker.tar.xz /
CMD ["/bin/bash"]
```


#### [COPY](https://docs.docker.com/engine/reference/builder/#copy)

- 基本上許多地方與 `ADD` 差不多, 但無法使用 URL 作為 src
- src 只能是相對於 context 底下的路徑
- src 如果是個 dir, 則會連同底下的東西全部 copy 到 Container (包含 filesystem metadata)
    - dir 不會被 copy, 只有內容會
- 若 src 為 file, dest 結尾多了個 /, 則會被視為放到 `dest/file`
- 若 src 指定了多個檔案, 則 dest 必須為 / 結尾
- 若 src 為 file, dest 沒有 / 結尾, 則會被視為寫入到 `dest` (file)
- 若 dest 路徑不存在, 則整個結構會被建立
- 關於 COPY, 也有 cache 的問題, 遇到再說


#### [FROM](https://docs.docker.com/engine/reference/builder/#from)

- ARG 這個階段, 是唯一能夠放在 FROM 以前
- 一個 Dockerfile 裡面可以有多個 FROM 階段
    - 此可用來建構多個 Images
    - 此也可用來作為 Image 之間的依賴
- 可為 FROM 配上 `AS name`, 此 name 可用來作為後續 `FROM <name>` 以及 `COPY --from=<name>` 使用

------

`ARG` 與 `FROM` 之間的互動.... 有點無聊啊...

```dockerfile
# ARG 定義的變數, 可以給 FROM 階段使用
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}
CMD  /code/run-app

FROM extras:${CODE_VERSION}
CMD  /code/run-extras
```

```dockerfile
# 但像是在 FROM 外部(上面) 的 ARG 聲明, 如果要在 FROM 階段使用的話, 需要在此內部在聲明一次 ARG
ARG VERSION=latest
FROM busybox:$VERSION
ARG VERSION
# ^ 像這樣, 不要給值
RUN echo $VERSION > image_version
# ^ 就可以使用了
```

#### [ENV](https://docs.docker.com/engine/reference/builder/#env)

ENV 這階段, 定義了以後, 會存活於 Image building time 的所有階段. 並且在 Container runtime 也會存在

相較之下, `ARG` 只會在 Image building time 存在, Image 建置完成後就不存在了

ENV 的寫法:
- `ENV NAME=tony`
    - 可使用 單行 多變數 指定
- `ENV NAME tony`
    - 不建議再使用!
    - 只是為了歷史性地向後兼容
    - 可能造成混淆, ex: `ENV result world=` (這可能會嚇到人家)

ENV 的壞處就是, 一但設定了以後, 有一點點可能會影響到 dockerfile 運行 build 的階段, 剛好你這訂的變數, 影響了 building time 的某個指令

也可使用像是:

```dockerfile
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ...
# 此處的 DEBIAN_FRONTEND 則只存活於 building time
# 但與其這樣, 覺得用 ARG 還比較不會讓人混淆
```



#### [Environment replacement](https://docs.docker.com/engine/reference/builder/#environment-replacement)

------

`${variable:-word}`, if variable, 
    - then: $variable
    - else: $word

------

`${variable:+word}`, if variable, 
    - then: $word
    - else: ""

------

```dockerfile
ENV abc=hello
ENV abc=bye def=$abc
ENV ghi=$abc
```

最終結果, abc = bye , def = hello , ghi = bye

上述的這些 ENV, 只有在 image build 階段有用, runtime 期間則無用

------


#### [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose)

這東西, 可視為 建構 Image 與 運行 Container 兩者之間的文件

可透過 `docker run -p` 來複寫 dockerfile 內部定義的 `EXPOSE`


#### [LABEL](https://docs.docker.com/engine/reference/builder/#label)

我覺得這很無聊... 遇到要用再來看了


#### [MAINTAINER](https://docs.docker.com/engine/reference/builder/#maintainer-deprecated)

這個更無聊, 已經被 deprecated. 使用 `LABEL` 來代替
