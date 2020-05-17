Task:

Descripton:

    Sample nginx docker image that exposes on 8880 and 8443 with SSL certs.

Working:

    $ docker build -t image-name:tag .

    $ docker run -itd -p 8880:8880 -p 8443:8443 --name demo image-name:tag