- 2021/01/02
- [Sending Email](https://developers.google.com/gmail/api/guides/sending#python_1)

Gmail 發送信件的 2 種方法:
- messages.send
- drafts.send

[Gmail 的內容格式](https://developers.google.com/gmail/api/reference/rest/v1/users.messages):
- Gmail API 需要符合 MIME email messages (符合 RFC 2822(別鳥她))
- 把上面那包, encode with base64
- 把上面那包, 放入 **message resource** 的 raw 欄位

```py
mm = MIMEText(message_text)
mm['to'] = to
mm['from'] = sender
mm['subject'] = subject
message_resource={'raw': base64.urlsafe_b64encode(str(mm.as_string()))}
```

