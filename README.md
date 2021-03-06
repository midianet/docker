# docker
# Tutorial Docker Network + apache proxy reverso

## Instalações Ubuntu 18/20 Mint

### Docker

```
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
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
# crie o arquivo index.html com o conteudo na pasta appa/index.html acima
```
### Dockerfile

```
#crie o arquivo Dockerfile como o arquivo acima Dockerfile
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
# crie o arquivo index.html com o conteudo na pasta appb/index.html acima
```

### Dockerfile
```
#crie o arquivo Dockerfile como abaixo
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
# crie o arquivo appa.conf com o conteudo do arquivo appa.conf
# crie o arquivo appb.conf com o conteudo do arquivo appb.conf
```
## Reload Apache2 service

```
docker exec apache service apache2 reload
```
## Configurar dns local
```
#como nao temos um dns e esse exemplo e apenas para aprendizado
#edite o arquivo /etc/hosts como as linhas abaixo
```
```
127.0.0.1 appa.local
127.0.0.1 appb.local
```

```
#teste acessando no browser http://appa.local
#teste acessando no browser http://appb.local
```

#Fim


