#Lets Encrypt Automation

## Prerequisites

1. Make
2. Docker
3. doctl. 
> Docs -> [here](https://docs.digitalocean.com/reference/doctl/how-to/install/)

## Getting Started

1. Create an API token on digital ocean. 
> DigitalOcean Docs [https://docs.digitalocean.com/reference/api/create-personal-access-token/](https://docs.digitalocean.com/reference/api/create-personal-access-token/)

2. Copy the sample credential file to the credential file path

`cp ./certbot-creds-sample.ini ./certbot-creds.ini` 

3. Edit `./certbot-creds.ini` and add your token.

```ini
dns_digitalocean_token = dop_v1_supersecrettoken...
```

4. run `make help` to get a list of commands

