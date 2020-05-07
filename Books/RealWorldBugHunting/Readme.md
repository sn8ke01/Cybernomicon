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

