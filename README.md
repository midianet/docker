

## Listando redes
```
docker network ls
```

## Criando uma rede
```
docker network create --subnet=172.18.0.0/16 apps
docker network ls
docker network inspect apps
```

## Editando o Hosts
crie o conteudo abaixo no fim do arquivo hosts especifico do seu SO<br>
127.0.0.1 portal.local<br>
127.0.0.1 intranet.local<br>
127.0.0.1 comercial.local<br>
127.0.0.1 financeiro.local<br>

### Windows
Abra o powershell como administrador e execute o comando na pasta
```
cd C:\Windows\system32\drivers\etc
notepad hosts
```

### Linux
```
sudo vim /etc/hosts
```
### Testando
Teste a entrada executando o comando:
```
ping sitea.local
ping siteb.local
```

## Criando as configurações do NGinx
Crie o arquivo default.conf com o conteúdo do arquivo [default.conf](https://github.com/midianet/docker/blob/main/nginx/conf.d/default.conf) 
```
cd ~/docker/nginx
mkdir www
mkdir conf.d
cd conf.d
vim default.conf
```
Crie o arquivo intranet.conf com o conteúdo do arquivo [intranet.conf](https://github.com/midianet/docker/blob/main/nginx/conf.d/intranet.conf) 
```
vim intranet.conf
```
Crie o arquivo portal.conf com o conteúdo do arquivo [portal.conf](https://github.com/midianet/docker/blob/main/nginx/conf.d/portal.conf) 
```
vim portal.conf
```
## Criando os sites
### Portal
Crie o arquivo index.html com o conteúdo do arquivo [index.html](https://github.com/midianet/docker/blob/main/nginx/www/portal/index.html)
```
cd ~/docker/nginx/www
mkdir portal
cd portal
vim index.html
```

### Intranet
Crie o arquivo index.html com o conteúdo do arquivo [index.html](https://github.com/midianet/docker/blob/main/nginx/www/intranet/index.html)
```
cd ~/docker/nginx/www
mkdir intranet
cd intranet
vim index.html
```

## Criando o container do NGinx
```
docker run -d --name nginx -h nginx --net apps -p 80:80 -v ~/docker/nginx/conf.d:/etc/nginx/conf.d  -v ~/docker/nginx/www:/var/www nginx
```
- acesse http://localhost
- acesse http://sitea.local
- acesse http://siteb.local

## Criando a imagem siteA
```
cd ~/docker
mkdir siteA
cd siteA
vim index.html
```
Crie o arquivo index.html com o conteudo do arquivo [index.html](https://github.com/midianet/docker/blob/main/siteA/index.html)
```
vim Dockerfile
```
Crie o arquivo Dockerfile com o conteudo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/siteA/Dockerfile)

### Build da imagem
```
docker build -t [seu login dockerhub]/sitea
#exemplo midianet/sitea para latest
#exemplo midianet/sitea:1.0.0 para tag
```

## Criando uma imagem siteB
```
cd ~/docker
mkdir siteB
cd siteB
vim index.html
```
Crie o arquivo index.html com o conteudo do arquivo [index.html](https://github.com/midianet/docker/blob/main/siteB/index.html)
```
vim Dockerfile
```
Crie o arquivo Dockerfile com o conteudo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/siteB/Dockerfile)
docker build -t [seu login dockerhub]/siteb
#exemplo midianet/siteb para latest
#exemplo midianet/siteb:1.0.0 para tag
```

### Verificando as novas imagens
```
docker images
```

### Login registry docker hub
```

# Criando o container Site A
```
docker run -d --name sitea -h sitea --net app midianet/sitea:1.0.0
#se vc subiu sua imagem pode trocar midianet/sitea por [seu login dockerhub]/sitea
```

# Site B
```
docker run -d --name siteb -h siteb --net app siteb:1.0.0
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
