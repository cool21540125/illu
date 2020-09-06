all: f1
	@echo recipe \`\`all\'\' executed.
f2:
	@echo process 2:
	touch f2
f1:
	@echo process 1:
	touch f1
clean:
	rm f1
	rm f2
.PHONY: clean
# PHONY 用來定義 假工作目標, 若不這樣定義, 會讓 makefile 誤以為 'clean' 是個 file