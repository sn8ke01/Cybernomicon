# Real World Bug Hunting 
> Notes from the book of the same name by **Pete Yaworski** (https://nostarch.com/bughunting)

## Open (Unvalidated) Redirects

> The visited website sends the user's browser to a different URL that could exist in another domain.  This process can be highjacked by a malicous user and send a user to an evil website w/o the user being aware.

There are 3 main types of Open Redirects
1. URL Parameter
2. HTML <meta> tag
3. DOM (Document Object Model)

#### URL Parameter
Application uses an URL parameter to send a **GET** request to the destination URL.

In the below example the redirect paramerter is **redirect_to=** but is could be any number of things.

`https://www.google.com/?redirect_to=https://www.attacker.com`

Other paramerters to look out for:
**url=**
**next=**
**r=**

#### HTML <meta> Tag

**Open Redirect Detection**
Status Code of 3xx.  Typical Status Code of **302** but any 3xx.

Monitor your proxy for **GET** requests sent to the sire you're testing that includes the site you are testing.
