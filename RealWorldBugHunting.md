---
layout: post
title: Hunting like Elmer
---

# Real World Bug Hunting 
> Notes from the book of the same name by **Pete Yaworski** (https://nostarch.com/bughunting)
> The book includes a ton of real world examples pulled from bug bounty reports.  Those examples will not be included in these notes.

Table of Contents

=============

* [Open Redirects](#open-redirects)



## Open Redirects

> The visited website sends the user's browser to a different URL that could exist in another domain.  This process can be highjacked by a malicious user and send a user to an evil website w/o the user being aware.

There are 3 main types of Open Redirects
1. URL Parameter
2. HTML <meta> tag
3. DOM (Document Object Model)

#### URL Parameter
Application uses an URL parameter to send a **GET** request to the destination URL.

In the below example the redirect paramerter is **redirect_to=** but is could be any number of things.

```html
https://www.google.com/?redirect_to=https://www.attacker.com
```

Other paramerters to look out for:
**url=**
**next=**
**r=**

#### HTML <meta> Tag
HTML <meta> tag instructs the browser to refresh and make a **GET** request to a URL.
```html
<meta http-equiv="refresh" content="0; url=https://evil.com/">
```
This becomes a problem when the attacker can control what the `content` attribute and inject their own URL.

#### DOM (document object model)
The DOM is an API for the HTML and XML documents.  Attacker can redirect users to super evil URLs via JavaScript by inejecting a URL int the `window.location` property.

> The DOM Open Redirect requires the attacker be able to execute JavaScript ethier via XXS or an intential user specifiec URL.

```javascript
window.location = https://www.google.com
window.location.href = https://evil.com
window.location.replace(https://E.Corp)
```

#### Open Redirect Detection
Status Code of 3xx.  Typical Status Code of **302** but any 3xx.

Monitor your proxy for **GET** requests sent to the sire you're testing that includes the site you are testing.
