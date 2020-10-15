# Use multi-stage builds

- 2020/10/13
- Since v17.05
- [Use multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

以往在做部署時, 經常需要維護兩的 Dockerfile (一個包含了建置環境, 另一個包含了執行環境)

所以就很自然地產生了 `Dockerfile.build` && `Dockerfile`, 但這不是個好辦法

從 v17.05 以後, 多了有效的解決方法

