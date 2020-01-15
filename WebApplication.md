# Web Application

## HTTP Requests 

HTTP Requests have headers and methods

> VERB /resource HTTP/1.1

VERB = method type

```html
GET /index.php HTTP/1.1
Host: hostname
```

## Cookies

<details><summary>Cookies are composed of?</summary>
   
  **Key:Value** Pairs

```html
cookie: id=eccbc87e4b5ce2fe28308fd9f2a7baf3
```

</details>

## XSS

**<details><summary>Types</summary>**

1. Reflected
2. Stored (persistant)
3. DOM-based [very difficult to mitigate]

</details>

**Finding XSS**
1. Figure out where it goes. Does it get mebedded in a tag attribute? Does it get put into a string in a script tag?  Does user input do directly into the page in any way?
2. Figure out any special handiling: Do URLs get turned into links, like posts?
3. Figure out how special characters are handled: Input something like `'<>:;"`

**XSS** Tricks

`"><h1>test</h1>`

`'+alert(1)+'`

`"onmouseover="alert(1)`

`http://"onmouseover="alert(1)`


## Authentation Bypass Technique

Auth-Z _or_ Direct Object Reference

> Are admin components enumerable?

1. Perform as many actions as possible as as the highest level user possible
2. Record/track the requests
3. Replay requests as a low privileged user with altered session ID/CSRF token as needed










