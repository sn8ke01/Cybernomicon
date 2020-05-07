# Real-World Bug Hunting Summary

>  A quick of the attacks described in the book.  More detailed information can be found [here](RealWorldBugHunting.md "Why is all the rum gone?")

## Open Redirect

The visited website sends the user's browser to a different URL that could exists in another domain.  This process can be highjacked by a malicious pirate and send the user to an evil website where the user's booty get's stolen completely unaware.

## HTTP Parameter Pollution

This happens when a target website trusts the parameters injected by a pirate.  The parameters can lead to odd or terrible behavior (like living in the body of a mouse for extended periods of time).  There are two kinds of HPP:

1. <u>Client Side</u>: Allows pirates to inject extra params into a URL to create effects on the victim's end.  IE this happens on the victim's system or in their browser
2. ~~Strong~~ <u>Server Side</u>: The pirate sends the sever unexpected information (like bananas instead of a canon ball) in an attempt to elicit unexpected behavior (that you are somewhat expecting?) Mostly guess work.  Requires good testing to find.

