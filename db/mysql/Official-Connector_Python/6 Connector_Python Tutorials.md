# Chapter 6 Connector/Python Tutorials

本章節舉例說明如何使用 *MySQL Connector/Python* 來開發 DB app


## 6.1 Tutorial: Raise Employee's Salary Using a Buffered Cursor

> To iterate through the selected employees, we use buffered cursors. (A buffered cursor fetches and buffers the rows of a result set after executing a query

關於 *buffered cursor*, 參考 10.6.1

`cursor` 對於查詢結果, 不需要額外指定新變數, 它自己就是個查詢結果的 `iterator`