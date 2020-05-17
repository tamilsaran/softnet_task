#!/bin/bash

country=IN
state=MH
location=Pune
role=DevOps
company=demo
domain=demo.io
email=demo@demo.io

openssl req -x509 -nodes -days 365 -subj "/C=$country/ST=$state/L=$location/O=$role Corporation/OU=$company Department/CN=$domain/emailAddress=$email" -keyout privateKey.pem -out certificate.crt
