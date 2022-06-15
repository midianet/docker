

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

## App Comercial
### Criando a App Comercial 
Crie o arquivo index.html com o conteudo do arquivo [index.html](https://github.com/midianet/docker/blob/main/app-comercial/index.html)
```
cd ~/docker
mkdir app-comercial
cd app-comercial
vim index.html
```

### Criando o Dockerfile do App Comercial
Crie o arquivo Dockerfile com o conteudo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/app-comercial/Dockerfile)
```
vim Dockerfile
```

### Build da imagem do App Comercial
```
docker build -t [seu login dockerhub]/app-comercial:1.0.0
#exemplo midianet/app-comercial:1.0.0
```

## App Estoque
### Criando a App de Estoque 
Crie o arquivo index.html com o conteudo do arquivo [index.html](https://github.com/midianet/docker/blob/main/app-estoque/index.html)
```
cd ~/docker
mkdir app-estoque
cd app-estoque
vim index.html
```
### Criando o Dockerfile do App de Estoque
Crie o arquivo Dockerfile com o conteudo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/app-estoque/Dockerfile)
```
vim Dockerfile
```
### Build da imagem do App de Estoque
```
docker build -t [seu login dockerhub]/app-estoque:1.0.0
#exemplo midianet/app-estoque:1.0.0
```

### Verificando as novas imagens
```
docker images
```

# Criando o container do App Comercial
```
docker run -d --name app-comercial -h app-comercial --net app midianet/app-comercial:1.0.0
```

# Criando o container do App de Estoque
```
docker run -d --name app-estoque -h app-estoque --net app app-estoque:1.0.0
```

# Configurando proxy reverso no NGINX
Crie o arquivo comercial.conf com o conteúdo do arquivo [comercial.conf](https://github.com/midianet/docker/blob/main/nginx/conf.d/comercial.conf)<br>
depois crie o arquivo estoque.conf com o conteúdo do arquivo [estoque.conf](https://github.com/midianet/docker/blob/main/nginx/conf.d/estoque.conf)
```
cd ~/docker/nginx/conf.d
vim comercial.conf
vim estoque.conf
```

## Reload do Nginx service
```
docker exec nginx nginx -s reload
```
- acesse http://comercial.local
- acesse http://estoque.local

#Fim
