# docker
# Tutorial Docker Network + apache proxy reverso

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

## Criando uma imagem AppB

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

### Build da imagem 

```
docker build -t [seu login dockerhub]/appa
#exemplo midianet/appa para latest
#exemplo midianet/appa:1.0.0 para tag
```

### Verificando a imagem
```
docker images
```

### Login registry docker hub
```
docker login (usuario/senha) 
# so precisa fazer isso uma vez
```

### Push da imagem
```
docker push [seu login dockerhub]/appa
# exemplo dockerpush midianet/appa
```

## Criando uma imagem AppB


```
cd ..
mkdir appb
cd appb

# Vamos criar uma página apenas para demonstração
# crie o arquivo index.html
```
### index.html

```
<html>
    <head>
        <meta charset="UTF-8">
        <title>App B</title>
        <style>
            body{
                margin: 0;
                padding: 0;
                background-color:  #66c2ff;
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
                -webkit-box-shadow: 5px 5px 23px -5px  #0033cc;
                -moz-box-shadow: 5px 5px 23px -5px #999999;
                box-shadow: 5px 5px 23px -5px  #999999;
            }
        </style>
    </head>
    <body>
        <div class="box">
            <p class="texto">App B</p>
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

### Build da imagem 

```
docker build -t [seu login dockerhub]/appb
#exemplo midianet/appb para latest
#exemplo midianet/appb:1.0.0 para tag
```

### Verificando a imagem
```
docker images
```

### Login registry docker hub
```
docker login (usuario/senha) 
# so precisa fazer isso uma vez
```

### Push da imagem
```
docker push [seu login dockerhub]/appb
# exemplo dockerpush midianet/appb
```

# Apache 2 Proxy Reverso Container
```
# para nao perder tempo vamos usar uma imagem pronta configurada e testada
sudo mkdir /opt/apacheconf
sudo chmod ao+r -R /opt/apacheconf
docker run -itd --name apache --restart always -h apache --net webserver --ip 172.18.0.2 -p 80:80 -v /opt/apache:/etc/apache2/sites-enabled jmferrer/apache2-reverse-proxy
#teste acessando no browser http://localhost
```

# App A
```
docker run -itd --name appa --restart always --net webserver --ip 172.18.0.3 midianet/appa
#se vc subiu sua imagem pode trocar midianet/appa por [seu login dockerhub]/appa
```

# App B
```
docker run -itd --name appb --restart always --net webserver --ip 172.18.0.4 midianet/appb
#se vc subiu sua imagem pode trocar midianet/appb por [seu login dockerhub]/appb
```

# Configurando proxy reverso
```
cd /opt/apacheconf
# crie o arquivo appa.conf com o conteudo abaixo
```
### appa.conf
```
<VirtualHost *:80>
    ProxyPreserveHost On
    
    ServerName appa.local 

    ServerAdmin midianet@gmail.com
    ErrorLog ${APACHE_LOG_DIR}/appa-error.log
    CustomLog ${APACHE_LOG_DIR}/appa--access.log combined
    
    ProxyPass / http://172.18.0.3:5000/
    ProxyPassReverse / http://172.18.0.3:5000/

</VirtualHost>
```
```
# crie o arquivo appb.conf
```

### appa.conf
```
<VirtualHost *:80>
    ProxyPreserveHost On
    
    ServerName appb.local 

    ServerAdmin midianet@gmail.com
    ErrorLog ${APACHE_LOG_DIR}/appb-error.log
    CustomLog ${APACHE_LOG_DIR}/appb--access.log combined
    
    ProxyPass / http://172.18.0.4:5000/
    ProxyPassReverse / http://172.18.0.4:5000/

</VirtualHost>
```
## Reload Apache2 service

```
docker exec apache service apache2 reload
#teste acessando no browser http://appa.local
#teste acessando no browser http://appb.local
```

