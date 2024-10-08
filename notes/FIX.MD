# Common defenses against CSRF

Nowadays, successfully finding and exploiting CSRF vulnerabilities often involves bypassing anti-CSRF measures deployed by the target website, the victim's browser, or both. These are the most common defenses:

- **CSRF Tokens** - a CSRF token is a unique, secret, and unpredictable value that is generated by the server-side application and shared with the client. When attempting to perform a sensitive action, such submitting a form, the client must include the correct CSRF token in the request. This makes it very difficult for an attacker to construct a valid request on behalf of the victim.

- **SameSite Cookies** - SameSite is a browser security mechanism that determines when a website's cookies are included in requests originating from other websites. As requests to perform sensitive actions typically require an authenticated session cookie, the appropriate SameSite restrictions may prevent an attacker from triggering these actions cross-site.

- **Referer-based validation** - some applications make use of the HTTP Referer header to attempt to defend against CSRF attacks, normally by veryfing that the request originated from the application's own domain. This is generally less effective than CSRF token validation.
