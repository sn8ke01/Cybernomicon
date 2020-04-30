# Email Delivery & Macro Fundies

## Email Delivery
**Summary up front**
> When planning to spoof email messages/domains:
> - Check if domain has SPF, DKIM, and/or DMARC enabled (See below)
> - Send message to non-existing user and analyze the non-delivery notice headers for info
> - **If spoofing is not an option** take a "legit" approach
> 	- Register a domain
>	 - Set up SPF, DKIM, and DMARC
> 
>:boom: Watch out for Spam Traps 


**Sender Policy Framework (SPF)**
Standard to verify sender address (IP) the message claims.

:exclamation: SPF is not cabable of verify message content

In order for SPF to work properly the following actions must be performed:
1. Mail servrer that recives a message **must** verify the SPF record
2. Domain owner must **creat an SPF record**

[Create SPF and DKIM records](https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf)

[Create SPF Record](https://www.dmarcanalyzer.com/spf/how-to-create-an-spf-txt-record/)

*Lookup an SPF record*
$> dig +short TXT domain.tld
```
dig +short TXT twitter.com
```

**DomainKeys Identified Mail (DKIM)**
DKIM can be used by the mail server to sign the message and its content.  

A DKIM header is used for the signing process.

Verification is performed by a server through a query of the domain's public key.

*Lookup DKIM record*
$> dig +short TXT **selector**._domainkey.domain.tld

```
dig +short TXT dkim._domainkey.twitter.com
```
**Domain-based Message Authentication, Reporting and Conformance (DMARC)**

DMARC is a standard that will allow an owner to perform:
1. Announce DKIM and SPF usage
2. Adive other mail servers on action in the event a message fails a check

*Lookup DMARC record*
$> dig +short TXT _dmarc.domain.tld
```
dig +short TXT _dmarc.wordpress.com
```
___
## Prevent Spam from your domain in MS Exhange Server
**Accepted Domains** tells Exhange which domains to accept email for.
See this article for more detail: [Accepted Domains](https://exchangepedia.com/2008/09/how-to-prevent-annoying-spam-from-your-own-domain.html)
___

## Spam Traps
Factors and email components taken into consideration by spam filters

- Domain's age
- Links pointing to an IP address
- Link manipulation techniques
- Suspicous (ucommon) attachments
- Broken email content
- Values used different to those on the emial headers
- Existance of valid and trusted SSL cert
- Submission of page to web content filtering sites
