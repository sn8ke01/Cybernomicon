# Recon It ALL

- [ ] Robots.txt
- [ ] URLs
- [ ] Domains
- [ ] Sub Domains
- [ ] Sub Sub Domains 
- [ ] IP & BGP
- [ ] JS Files
- [ ] API Endpoints
- [ ] Tech
- [ ] Amazon Buckets
- [ ] Github
- [ ] Google Searches
- [ ] Email Searches
- [ ] Social Media


## Robot.txt
Get a list of robots.txt for analysis. Look for potential targets for further inspection.

`python waybackrobots.py`

## URLs
Get a list of URLs for further investigation.

**waybackurls** outputs to JSON format.

`python waybackurls.py`

Pasre the JSON with `jq`

```bash
cat somefile-waybackurls.json | jq -r '.[] |@tsv'
```

## Domains
Create a list of related domains.  This can be done with a variety of tools.

**Amass** `amass enum -d $domain -o $outfile.amass`

**DNS Recon** `python3 $dnsrecon -d $domain --dictionary $dictionary --csv $outfile.dnsrecon.csv`

**SubFinder** `subfinder -d $domain -b -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -o $domain.subfinder`

## Sub Domains
 - Identify subdomains: *.tesla.com *=wildcard. 

**Sublist3r** `python sublist3r.py -e google,yahoo,virustotal -d $domain`
This may need to be installed.
```bash
apt install sublist3r
```

**SubBrute** `subbrute -t $domain.list` *OR* `subbrute $domain` _run from SubBrute .py location_

### Online Resources for sub-domains

https://dnsdumpster.com/

https://searchdns.netcraft.com/

https://www.virustotal.com/

https://crt.sh

## Sub(sub) Domains
Locate sub sub domains for further investigation.

**AltDNS** `altdns.py -i $subdomain.list -o $output.data -w $word.list -r -s $out.file`

**SubBrute** again 

**Sub checks with EyeWitness** `python EyeWitness.py -f $subdomain.list`

### Onine Resource

https://www.yougetsignal.com/

## IP Information

**Domain IP** `dig $domain +short`

**IP Info** `whois $ip` *serch terms* `NetName` `NetRange` `CIDR`

### Online Resource

https://www.bgp4.as/looking-glasses

https://whois.arin.net/

## JS Files
Discover & use JS file to find additional endpoints to investigate

https://github.com/zseano/InputScanner

https://github.com/zseano/JS-Scan

## API Endpoints
Discover API endpoints

[ProgamableWeb](https://nordicapis.com/api-discovery-15-ways-to-find-apis/www.programmableweb.com)

[APIs](http://apis.io/)

**APIs search query** `curl -X GET http://apis.io/api/search?q=$target`

[Google API Explorer](https://developers.google.com/apis-explorer/#p/)


## Tech
Discover tech used by a website or system

**Wappalizer** add on for *Chrome* & *Firefox*

**https://builtwith.com/** looks at tech webapp is running

## Amazon Buckets

**Google Dork** `site:amazonaws.com inurl:$target`

**Bucket Finder** `bucket_finder.rb --Log-file bucket.out $words` [Bucket Finder](https://digi.ninja/projects/bucket_finder.php)

**Aws CLI** `aws s3 ls s3://$target` 

## Github
Search github for tidbits

**TruffleHog** `truffleHog --regex --entropy=False https://github.com/$target/`

**GitHub UI Search Terms**
```
target.com dev
dev.taget.com
target.com API_key
target.com password
api.target.com
```

**Google Dork** `site:github.com taget password`

## Google Searches - Additinal Discovery
Use Google to discover other details about the target

[Google Search Syntax](https://ahrefs.com/blog/google-advanced-search-operators/)

**Tech related File Types search _filetype_ **
```
site:target filetype:
php
aspx
swf
wsdl
```

**URI Paremeters**
```
insite:target inurl:.php?
id=
user=
book=
```

**Tech related File Types search _inurl_ OR _intext_ **
```
site:target inurl:
login.php
portal.php
register.php

site:target intext:
login
```

**Directory Structure** `site:target intext:"index of /"`

**Intersting Searchs**
```
site:target filetype:txt
site:target inrul:php.txt
site:target ext:txt
```

## Email Searches

**Hunter.io** search for company user emails.  May need an API key for more efficein scans.

## Social Media
Twitter, Linkdn, etc..

## Additinal Discovery

**GoBuster** `gobuster -w worklist -u http://target.com`

## Primary Resources

**Recon Like a Boss** [ReconLikeaBoss](https://bugbountytuts.files.wordpress.com/2019/01/dirty-recon-1.pdf)

**Advanced Persistent Threat Hacking - Chapters 4 & 5** [APT Hacking](https://www.amazon.com/Advanced-Persistent-Threat-Hacking-Organization-ebook-dp-B00P1JSNJA/dp/B00P1JSNJA/ref=mt_kindle?_encoding=UTF8&me=&qid=1580411251)


## Unorginized Notes

- Tomnomnom httprobe: probes list to check status or URLs
`go get -u github.com/tomnomnom/httprobe`

