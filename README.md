# Tutorial Docker

## Instalando Docker (Ubuntu 18/20 Mint)
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

#### Instalando o VIM
```
 sudo apt install vim
```

### Testando instalção
```
docker -v
```

## Docker Images

### Baixando imagens
```
docker pull hello-world

```

### Listando imagens
```
docker images
```
  -a, --all             Mostra todas as imagens (por padrão esconde as imagens intermediarias)<br>
      --digests         Mostra o hash<br>
  -f, --filter filter   Filtra a saída do comando<br>
      --format string   Formata a saída do comando<br>
      --no-trunc        Não trunca a saída do comando<br>
  -q, --quiet           Mostra apenas os IDs das imagens<br>

### Criando uma imagen (Dockerfile) 
```
 cd 
 pwd
 mkdir nginx
 cd nginx
 vim Dockerfile
```
Crie o arquivo Dockerfile com o conteúdo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/Dockerfile) 

### Construindo uma Imagem
```
docker build -t local-teste:1.0.0 .
```
Editar a imagem concatenando os comandos RUN
Conferir Diferença entre tamanhos de imagem (novas camadas)<br>
```
docker build -t local-teste:1.0.1 .
docker images
```
criar uma imagem ubuntu com o nginx
```
docker build -t local-nginx-ubuntu .
```
criar outra imagem usando de base um alpine
```
docker build -t local-nginx-alpine .
docker images
```

### Tageando uma imagem
Se não tem crie um usuário no http://dockerhub.com<br>
Ative seu usuário no seu email
```
docker tag [usuario dockerhub]/nginx-alpine
```

### Removendo uma imagem
```
docker rmi local-nginx-ubuntu
docker rmi local-nginx-alpine
docker rmi local-teste:1.0.0
docker rmi local-teste:1.0.1
```

### Subindo uma imagem no Dockerhub(registy)

```
 docker login
 docker push [usuario dockerhub]/nginx-alpine
```

### Criando uma imagem de container
Possibilita criar uma imagem usando um container
```
docker commit [nome] [nome imagem]:[tag]
```
 
## Containers
Para mostrar os próximos exemplos iremos executar o comando abaixo como insumo (vamos explicar esse comando posteriormente)<br>
Uum container so se mantem em execução enquanto o processo que o iniciou esteja vivo
```
docker run -itd alpine
docker run hello-world
```

### Visualizando containers em execução
```
docker ps
```
### Visualizando todos os containers (execução ou parados)
```
docker ps -a
```
Observe:<br>
Temos um container em execução da imagem alpine
Temos um container parado (exit) da imagem hello-world

### Criando um Container
https://docs.docker.com/engine/reference/run/<br>
docker run [opções] [imagem] [comando] [argumentos...]

#### Opções
 -i #permite iteração com o container<br>
 -t #chama a tty (saída, output) do comando<br>
 -d dettached #cria o container destacado
```
docker run -it ubuntu
```
Para sair de um container sem matar o processo(bash no caso acima) use Ctrl p q (não consegui rodar no wsl terminal)
```
docker run -itd ubuntu #pode juntar como -itd , a ordem não importa
```

### Parâmetro que define o Nome do container 
```
docker run -itd --name meu-ubuntu ubuntu
docker run --name meu-ubuntu ubuntu
#rodou?
```

### Parâmetro que define o Nome Interno do container(host)
```
docker run -it -h meuserver ubuntu
hostname  #comando linux
exit      #comando linux
```

### Parâmetro que define o bind de porta
Porta que será exposta pelo host)<br>
-p [HOSTPORT]:[CONTAINERPORT]
```
docker run -d --name nginx-80 -p 80:80 nginx
docker run -it -p 80:80 nginx
#rodo?
docker run -d --name nginx-8080 -p 8080:80 nginx
```

### Parâmetro quefine a forma de Inicialização Automática do container
 --restart [OPTION]<br>
   always #inicia junto com o docker<br>
   on-failure:10, #inicia sempre, mas se falhar (10) vezes não tenta mais<br>
   unless-stoped #inicia se o estado anterior não for parado
```
docker run -itd --name automatico --restart always ubuntu
docker ps
sudo service docker restart
docker ps
```

### Parâmetro que define se o container irá ser Destruido Automaticamente após parado
```
docker run -it --rm --name temporario ubuntu
exit #comando linux
```

### Parâmetro que define o Usuário que ira por padrão executar o container
```
docker run -it --rm -u daemon ubuntu
exit #comando linux
```

### Parâmetro que define o path inicial do container
```
docker run -it --rm -w /tmp ubuntu
exit #comando linux
```

### Enviando argumentos para um container
```
docker run -it --rm -e ANIMAL=lobo -e CACADOR=joao -e ARMA=espingarda ubuntu
env  #comando linux
exit #comando linux
```
### Observando os parâmetros de recursos de um container
```
docker stats automatico
ctrl c
```

### Parâmetro que define o recurso de Memória do container
-m [SIZE] ou --memory , (b,k,m,g)
```
docker run -m 200k ubuntu  
#rodou?
docker run -itd --name men-limitado --rm -m 10m ubuntu
docker stats men-limitado
#ctrl C
```
### Parâmetro que define o recurso de Memória Swap do container
--memory-swap,(b,k,m,g)
```
docker run --rm --memory-swap 5m ubuntu
#rodou?
docker run --rm -m 10m --memory-swap 5m ubuntu
#rodou?
docker run --rm -m 10m --memory-swap 15m ubuntu
```

### Parâmetros que definen o recurso de CPU
#### Definindo o número fracionário de CPU
--cups - Especifica quanto dos recursos de CPU disponíveis um contêiner pode usar
--cpu-period - Especifica o período do agendador CFS da CPU, que é usado junto com --cpu-quota.<br>
   O padrão é 100.000 microssegundos (100 milissegundos).<br>
   A maioria dos usuários não altera isso do padrão. Para a maioria dos casos de uso, --cpus é uma alternativa mais conveniente.
--cpu-quota - Especifica uma cota de CPU CFS no contêiner.<br> 
   Para a maioria dos casos de uso, --cpus é uma alternativa mais conveniente.<br>
--cpuset-cpus - Especifica as CPUs ou núcleos que o contêiner pode usar.<br>
   lista separada por virgula ou - (hifen) para intervalo<br>
   Onde a primeira CPU é 0. ex:<br> 
      0-3(primeira, segunda, terceira CPU)<br> 
      1,3(segunda e quarta CPU)<br>
--cpu-shares - Aumentar ou reduzir o peso do contêiner e fornecer acesso a uma proporção maior ou menor dos ciclos de CPU<br>
   por padrão e 1024
```
docker run --rm --cpus="0.5" ubuntu
docker run --rm --cpus="0.5" --cpu-period="100000" --cpu-quota=50000 ubuntu 
#rodou?
docker run --rm  --cpu-period="100000" --cpu-quota=50000 --cpuset-cpus=1,3 --cpu-shares=1000  ubuntu
```

### Parâmetros que definen o recurso de GPU
Existem formas de Especificar o uso de GPU, mas como depende do hardware iremos apenas revisar<br>
 --gpus all  - Habilita todas as GPU's para uso do contêiner<br>
 --gpus device= - Especifica qual GPU será habilitada para aquele container<br> 
 --gpus 'all,capabilities=utility Especifica qual recurso esta disponível na GPU para o container

### Executando comandos em um container
Para isso o container deverá estar em execução, esse comando será executado em uma nova sessão
```
docker run -itd --name exemplo -p 9090:80 nginx
docker exec exemplo ls /etc
docker exec -it exemplo bash
exit  #comando linux 
docker ps
#morreu?
```

### Anexando a entrada e saída padrão de um container
 Isso permite visualizar sua saída em andamento ou controlá-la interativamente,<br>
 como se os comandos estivessem sendo executados diretamente em seu terminal.
```
docker attach exemplo
ctrl c
docker ps
```

### Iniciando um container parado
Se o container não foi criado com --rm ao finalizar o comando ele fica em estado parado 
```
docker start exemplo
docker ps
```

### Parando um container em execução
Se o container foi criado com --rm ele será eliminado<br>
no contrário ele apenas ira ficar em estado parado e seus
arquivos internos será mantido
```
docker exec exemplo touch /root/meuarquivo 
docker stop exemplo
docker start exemplo
docker exec exemplo ls /root
docker run -itd --name doril --rm ubuntu
docker exec doril touch /root/meuarquivo
docker stop doril
```

### Congelando um container em execução
```
docker pause exemplo
docker ps
```

### Descongelando um container em execução
```
docker unpause exemplo
docker ps
```

### Reiniciando um container
Reinicia um container mas não perde seu estado..
```
docker restart exemplo
```

### Inspecionando um container
```
docker inspect exemplo
```

### Removendo um container
#Remove um container<br>]
Se o container esta em execução pode ser forçar com o parametro -f<br>
 Ex: docker rm -f [nome container]
```
docker ps
docker rm men-limitado
#rodou?
docker rm -f exemplo
docker rm -f men-limitado
docker rm -f automatico]
docker rm nginx-8080
docker rm nginx-80
docker rm meu-ubuntu
#desafio apague todas as imagens (paradas) que restaram e vc identifica que foram criadas para o treinamento
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


