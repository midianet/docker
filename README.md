# docker
# Tutorial Docker Network

## Instalações Ubuntu 18/20 Mint

### Docker

```
sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo reboot now
```
##### Testando instalção
```
docker ps
```

# Docker network

## Listando redes

```
docker network ls
```

## Criando uma rede

```
docker network create --subnet=172.18.0.0/16 webserver
docker network ls
docker network inspect webserver
```

## Criando uma imagem


```
mkdir appa
cd appa

# Vamos criar uma página apenas para demonstração
# crie o arquivo index.html
```
### index.html

```

<html>
    <head>
        <meta charset="UTF-8">
        <title>App A</title>
        <style>
            body{
                margin: 0;
                padding: 0;
                background-color: azure; /* #66c2ff;*/
            }
            .texto{
                font-size: 60px;
                font-family: Verdana, Geneva, Tahoma, sans-serif;
                color: slategrey;
                margin: 2px;
            }
            .box{
                position: absolute;
                margin: auto;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
                border-style: solid;
                border-width: 2px;
                text-align: center;
                border-color: lavender;
                width: 350px;
                height: 75px;
                background-color: white;
                border-radius: 8px;
                -webkit-box-shadow: 5px 5px 23px -5px #999999; /* #0033cc*/
                -moz-box-shadow: 5px 5px 23px -5px #999999;
                box-shadow: 5px 5px 23px -5px  #999999;
            }
        </style>
    </head>
    <body>
        <div class="box">
            <p class="texto">App A</p>
        </div>
    </body>
</html>
```

```
#crie o arquivo Dockerfile como abaixo
```
### Dockerfile

```
FROM  node

RUN apt update && npm install -g serve
RUN mkdir /opt/site
ADD index.html /opt/site
EXPOSE 5000
CMD serve -n /opt/site
```





FROM  node

RUN apt update && npm install -g serve
RUN mkdir /opt/site
ADD index.html /opt/site
EXPOSE 5000
CMD serve -n /opt/site
```
