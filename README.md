# Cross Site Request Forgery (CSRF)

This application has a Cross-Site Request Forgery (CSRF) vulnerability. 

## What is CSRF?

It's a web security vulnerability that allows an attacker to induce users (social engineering) to perform actions that they do not intend to perform. It allows an attacker to partly circumvent the same origin policy, which is designed to prevent different websites from interfering with each other.

## Impacts

In a successful CSRF attack, the attacker causes the victim user to carry out an action unintentionally. For example, this might be to change the email address on their account, to change their password, or to make a funds transfer. Depending on the nature of the action, the attacker might be able to gain full control over the user's account. If the compromised user has a privileged role within the application, then the attacker might be able to take full control of all the application's data and functionality.

## How does CSRF work?

For a CSRF attack to be possible, three key conditions must be in place:

- **A relevant action.** There is an action within the application that the attacker has a reason to induce. This might be a privileged action (such as modifying permissions for other users) or any action on user-specific data (such as changing the user's own password or transfer funds). 

- **Cookie-based session handling**. Performing the action involves issuing one or more HTTP requests, and the application relies solely on session cookies to identify the user who has made the requests. There is no other mechanism in place for tracking sessions or validating user requests.

- **No unpredictable request parameters.** The requests that perform the action do not contain any parameters whose values the attacker cannot determine or guess. For example, when causing a user to change their password, the function is not vulnerable if an attacker needs to know the value of the existing password.

- **Form.** A form that is not sending an extra token or is not asking for confirmation of an action can be vulnerable.

For example, suppose an application contains a function that lets the user change the email address on their account. When a user performs this action, they make an HTTP request like the following:

```
POST /email/change HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-ww-form-urlencoded
Content-Length: 30
Cookie: session=yvthwsztyeQkAPzeQ5gHgTvlyxHfsAfE

email=wiener@normal-user.com
```

This meets the conditions required for CSRF:

- The action of changing the email address on a user's account is of interest to an attacker. Following this action, the attacker will typically be able to trigger a password reset and take full control of the user's account.

- The application uses a session cookie to identify which user issued the request. There are no other tokens or mechanisms in place to track user sessions.

- The attacker can easily determine the values of the request parameters that are needed to perform the action.

With these conditions in place, the attacker can construct a web page containing the following HTML:

```html
<html>
    <body>
        <form action="https://vulnerable-website.com/email/change" method="POST">
            <input type="hidden" name="email" value="pwned@evil-user.net" />
        </form>
        <script>
            document.forms[0].submit();
        </script>
    </body>
</html>
```

If a victim user visits the attacker's web page, the following will happen: 

- The attacker's page will trigger an HTTP request to the vulnerable website.

- If the user is logged in to the vulnerable website, their browser will **automatically** include their session cookie in the request (assuming SameSite cookies are not being used).

- The vulnerable website will process the request in the normal way, treat it as having been made by the victim user, and change their email address.

*Note: although CSRF is normally described in relation to cookie-based session handling, it also arises in other contexts where the application automatically adds some user credentials to requests, such as HTTP Basic authentication and certificate-based authentication.*

## How to deliver a CSRF exploit

Typically, the attacker will place the malicious HTML onto a website that they control, and then induce ictims to visit that website. This might be done by feeding the user a link to the website, via an email or social media message. Or if the attack is placed into a popular website (for example, in a user comment), they might just wait for users to visit the website.

Note that some simple CSRF exploits employ the GET method and can be fully self-contained with a single URL on the vulnerable website. In this situation, the attacker may not need to employ an external site, and can directly feed victims a malicious URL on the vulnerable domain. In the preceding example, if the request to change email address can be performed with the GET method, then a self-contained attack would look like this:

```html
<img src="https://vulnerable-website.com/email/change?email=pwned@evil-user.net">
```

Sometimes, the endpoint just accepts JSON data and it's necessary to create a manipulated form to send data to backend:

```html
<input name="{"itemName":"apple", "junk":"" value="test"}">
```

Translates to: ```{"itemName":"apple", "junk":"=test"}```

It's also possible to use ```fetch()```. SOP blocks read but not sending data.
