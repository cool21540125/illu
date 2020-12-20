


# noums

- throttle : [限流](https://www.django-rest-framework.org/api-guide/throttling/)


# Views

- [Class-based Views](https://www.django-rest-framework.org/api-guide/views/#api-policy-instantiation-methods)
- 2020/12/20


### Notes

- request 由 `Django 的 HttpRequest` -> `DRF 的 Request`
- response 由 `Django 的 HttpResponse` -> `DRF 的 Response`
- view 處理 request 時, 會依照 content negotiation 來做 response

DRF 的 `class Based view` 處理了:
- Request 的 content negotiation
- 任何的 APIException
- 先做 verify, auth, identity, 再來處理 request

`(DRF)APIView` 繼承自 `(Django)View`

#### DRF View 屬性

```py
from rest_framework import authentication, permissions
.authentication_classes = [authentication.TokenAuthentication]
.permission_classes = [permission.IsAdminUser]
```

#### API Policy 實例方法:

```py
.get_permissions(self)  # @@
.get_throttles(self)  # @@
.get_content_negotiator(self)  # @@
.get_renderers(self)
.get_parses(self)
.get_authenticators(self)
.get_exception_handler(self)
```

#### API Policy 實作方法:

驅動 handlers 之前, 會優先調用 (應該就是調用上面的 @@)

```py
.check_permissions(self, request)
.check_throttles(self, request)
.perform_content_negotiation(self, request, force=False)
```


#### APIView Dispatch

若對 View 做了 @@, 後續 `驅動的行為(action), 也就是 dispatch()`

@@ 如下:

- .get()
- .post()
- .put()
- .patch()
- .delete()


#### Dispatch

##### .initial(self, *args, **kwargs)

用裡強制處理 上述的 @@

##### .handle_exception(self, exc)

用裡捕捉 action 內部任何的 Exception, 包裹成 `APIException` 後再做 response

##### .initialize_request(self, request, *args, **kwargs)

將 `(Djgnao)HttpRequest` -> `(DRF)Request`

##### .finalize_response(self, request, response, *args, **kwargs)

將 `(DRF)Response`, 依照 content type 作回傳
