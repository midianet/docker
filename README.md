# docker
# Tutorial Docker Network + nginx proxy reverso

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
docker -v
```

# Docker Images

### Baixando imagens
```
docker pull hello-world
```

### Listando imagens
```
docker images
#Ajuda do comando
docker images -h 
```
  -a, --all             Mostra todas as imagens (por padrão esconde as imagens intermediarias)<br>
      --digests         Mostra o hash<br>
  -f, --filter filter   Filtra a saída do comando<br>
      --format string   Formata a saída do comando<br>
      --no-trunc        Não trunca a saída do comando<br>
  -q, --quiet           Mostra apenas os IDs das imagens<br>
  

### Criando uma imagen
#### Instalando o VIM
```
 sudo apt install vim
```
#### Criando um Dockerfile 
```
 cd 
 pwd
 mkdir nginx
 cd nginx
 vim Dockerfile
```
Crie o arquivo Dockerfile  com o conteúdo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/Dockerfile) 

### Construindo uma Imagem
```
docker build -t [nome] #(latest)
```

### Tageando uma imagem
```
docker tag [imagem] [novo nome]:[tag]
```

### Removendo uma imagem
```
docker rmi [imagem]
```

### Subindo uma imagem no Dockerhub(registy)
Se não tem crie um usuário no http://dockerhub.com<br>
Ative seu usuário no seu email
```
 docker login
 docker push [imagem]
```
Conferir Diferença entre tamanhos de imagem (novas camadas)<br>

### Criando uma imagem a partir de um container
```
docker commit [nome] [imagem]:[tag]
```
 
## Containers



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

## Editando o Hosts
```
sudo vim /etc/hosts
#crie no final do arquivo as entradas como abaixo.
127.0.0.1       sitea.local
127.0.0.1       siteb.local
```
## Criando a configuração do NGinx
```
cd ~
mkdir docker
cd docker
mkdir nginx
cd nginx
mkdir www
mkdir conf.d
cd conf.d
#crie o arquivo default.conf com o conteúdo da pasta nginx/conf.d/default.conf
#crie o arquivo sitea.conf com o conteúdo da pasta nginx/conf.d/sitea.conf
#crie o arquivo siteb.conf com o conteúdo da pasta nginx/conf.d/siteb.conf
cd ../www
mkdir default
mkdir siteA
mkdir siteB
cd default
#crie o arquivo index.html com o conteúdo da pasta www/default/index.html
cd ../siteA
#crie o arquivo index.html com o conteúdo da pasta www/siteA/index.html
cd ../siteB
#crie o arquivo index.html com o conteúdo da pasta www/siteB/index.html
```

## Criando o container do NGinx
```
docker run -d --name nginx -h nginx --net webserver -p 80:80 -v ~/docker/nginx/conf.d:/etc/nginx/conf.d  -v ~/docker/nginx/www:/var/www nginx
```
- acesse http://localhost
- acesse http://sitea.local
- acesse http://siteb.local


## Criando a imagem siteA

```
cd ..
mkdir siteA
cd siteA
#crie o arquivo index.html com o conteudo da pasta siteA/index.html
#crie o arquivo Dockerfile com o conteudo da pasta siteA/Dockerfile
docker build -t [seu login dockerhub]/sitea
#exemplo midianet/sitea para latest
#exemplo midianet/sitea:1.0.0 para tag
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
docker push [seu login dockerhub]/sitea
# exemplo dockerpush midianet/sitea
```

## Criando uma imagem siteB


```
cd ..
mkdir siteB
cd siteB
#crie o arquivo index.html com o conteudo da pasta siteB/index.html
#crie o arquivo Dockerfile com o conteudo da pasta siteB/Dockerfile
docker build -t [seu login dockerhub]/siteb
#exemplo midianet/siteb para latest
#exemplo midianet/siteb:1.0.0 para tag
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
docker push [seu login dockerhub]/siteb
# exemplo dockerpush midianet/siteb
```

# Site A
```
docker run -d --name sitea -h sitea --net webserver midianet/sitea:1.0.0
#se vc subiu sua imagem pode trocar midianet/sitea por [seu login dockerhub]/sitea
```

# Site B
```
docker run -d --name siteb -h siteb --net webserver -p 3002:3000 siteb:1.0.0
#se vc subiu sua imagem pode trocar midianet/siteb por [seu login dockerhub]/siteb
```

# Configurando proxy reverso
```
# altere o arquivo na pasta ~/docker/nginx/conf.d/sitea.conf
# comente a linha 10 e descomente a linha 9
# altere o arquivo na pasta ~/docker/nginx/conf.d/siteb.conf
# comente a linha 10 e descomente a linha 9
```
## Reload do Nginx service

```
docker exec nginx nginx -s reload
```
- acesse http://sitea.local
- acesse http://siteb.local

#Fim


