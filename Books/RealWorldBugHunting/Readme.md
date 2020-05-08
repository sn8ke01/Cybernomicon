# Real-World Bug Hunting Summary

>  A summa of the attacks described in the book.  More detailed information can be found [here](RealWorldBugHunting.md "Why is all the rum gone?")

## Open Redirect

The visited website sends the user's browser to a different URL that could exists in another domain.  This process can be highjacked by a malicious pirate and send the user to an evil website where the user's booty get's stolen completely unaware.

## HTTP Parameter Pollution

This happens when a target website trusts the parameters injected by a pirate.  The parameters can lead to odd or terrible behavior (like living in the body of a mouse for extended periods of time).  There are two kinds of HPP:

1. <u>Client Side</u>: Allows pirates to inject extra params into a URL to create effects on the victim's end.  IE this happens on the victim's system or in their browser
2. ~~Strong~~ <u>Server Side</u>: The pirate sends the sever unexpected information (like bananas instead of a canon ball) in an attempt to elicit unexpected behavior (that you are somewhat expecting?) Mostly guess work.  Requires good testing to find.

## Cross-Site Request Forgery (CSRF)

A pirate makes the victim's browser send an HTTP request to another website.  The website then  performs the action as if it came from the victim (cause in a way it did).  

## HTML Injection and Content Spoofing

This allows a pirate to inject content into the website.  Think HTML elements.  The website gives the "user" the ability to write and some pirate comes along and figures out he can get HTML code to render.

For example a *Search* function/feature doesn't properly sanitize and the pirate can get the site to render something like this `<h4> This is a test</h4>` would actually get rendered onto the page.  See the possibilities?  Do you see? Do you see?

## Carrage Return & Line Feed Injection

CR & LF characters have special meaning and need to be properly sanitized. [Imagine how many dirty pirates would be stopped if we just properly sanitized?]  If a server does not deal with them properly they can be injected and a pirate can manipulate how the server handles the HTTP messages.

```http
%0D = \n (carriage return)
%0A = \r (Line Feed)
```

A CRLF injection can be used to achieve to other  types of HTTP related attacks:

1. HTTP Request Smuggling
2. HTTP Response Splitting 

## Cross-Site Scripting (XSS)

This happens with specific script related character are not sanitized and it allows a pirate to inject code that then gets executed. Classic example is `<script>alert(document.domain);</script>`

Main Character to look out for are `"`, `'`, `<`, `>`. 

## Template Injection

This happens when a *template engine* does not properly sanitize input.

A *template engine* is code that creates dynamic websites, emails, and other media by automatically filling in placeholders in the template when rendering.

## SQL Injection

A pirate is able to send unsanitized input (read *code*) directly to the back-end SQL server where is executed.

## Server-Side Request Forgery

This attack causes a server to perform unintended network requests, read, or update internal resources.  SSRF abuses another system to perform evil activity.  CSRF exploits another user and SSRF exploits a targeted application server.

In order to carry out this attack the pirate needs full or partial control of the request sent by the web application.

Initial detection requires some sort of server or listener to receive the request from the web application. `https://victim.org/foo.php?url=http://PirateBootyCove.plunder`

`http://PirateBootyCave.plunder` logs would tell me if the victim application `victim.org` made a request to my `PirateBootyCave` server

## XML External Entity

This takes advantage of application's process of handling XML *external entities*.

## Remote Code Execution

Application executes unsanitized input from the pirate.

## Memory Vulnerabilities

The attack exploits the applications terrible memory management.  Look for unintended behavior and the ability to inject & execute commands.

Discovering this booty requires a deeper understanding of memory management.  This book has some detail and may be a good stating point but consider additional material to take advantage of Mem Vulns

## Subdomain Takeover

A takeover happens when a pirate stakes claim to a subdomain from a legitimate site.  After the takeover the pirate can serve his own poisonous swill.  The subdomain that is taken over was probably at one time on one end of a CNAME (or other) DNS record that was then abandoned.   

```dns
lazy.victim.com	31337	IN	CNAME	forgot.3rdparty.com
```

In the above example `lazy` pointed to `forgot`.  Eventually `forgot` is no longer used but the record isn't removed, so the pirate goes into **3rdparty.com** and lays claim to the subdomain of `forgot` and every time someone visits `lazy` they go to `forgot` and get what ever swill is served up by the black bearded salty dog.

## Race Conditions

A Race condition happens when two or more process try and access the same object at the same time.  See, they both race to the same thing and run into each other...

## Insecure Direct Object Reference (IDOR)

When the pirate can modify an object's ID and then gain access to resources they should not have been able to see.

`https://www.victim.domain/account?id=1`0 -- What happens if you change `id=10` to `id=1`?  If you get access to something you shouldn't then you have yourself an IDOR.

## OAuth Vulnerabilities

Poor implementation of Oath can introduce bugs that could allow pirates to steal authorization tokens.

