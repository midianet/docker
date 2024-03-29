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

### Testando instalação
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
> -a,  --all Mostra todas as imagens (por padrão esconde as imagens intermediarias)<br>
> --digests Mostra o hash<br>
> -q, --quiet Mostra apenas os IDs das imagens<br>
> -f, --filter filter Filtra a saída do comando<br>
>>  --format string Formata a saída do comando<br>
>>  --no-trunc Não trunca a saída do comando<br>

### Criando uma imagen (Dockerfile) 
```
 cd 
 pwd
 mkdir nginx
 cd nginx
 vim Dockerfile
```
Crie o arquivo Dockerfile com o conteúdo do arquivo [Dockerfile](https://github.com/midianet/docker/blob/main/nginx/Dockerfile) 

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

### Removendo todas as imagens não usadas
```
docker image prune -a
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
 -it #permite iteração com o container e attacha a tty (saída, output) do comando<br>
 -d dettached #cria o container destacado
 Para sair de um container sem matar o processo(bash no caso acima) use Ctrl p q (não consegui rodar no wsl terminal)
```
docker run -it ubuntu
#ficou?  imagem do ubuntu não tem cmd
docker run -it ubuntu bash
docker run -d ubuntu bash
#ficou?
docker run -itd ubuntu bash
# a ordem não importa
docker run -d nginx
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
> --restart [opcao]<br>
>>   always inicia junto com o docker<br>
>>   on-failure:10, inicia sempre, mas se falhar (10) vezes não tenta mais<br>
>>   unless-stoped inicia se o estado anterior não for parado
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
-m [tamanho] ou --memory , (b,k,m,g)
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
> O padrão é 100.000 microssegundos (100 milissegundos).<br>
> A maioria dos usuários não altera isso do padrão. Para a maioria dos casos de uso, --cpus é uma alternativa mais conveniente.
--cpu-quota - Especifica uma cota de CPU CFS no contêiner.<br> 
> Para a maioria dos casos de uso, --cpus é uma alternativa mais conveniente.<br>
--cpuset-cpus - Especifica as CPUs ou núcleos que o contêiner pode usar.<br>
> lista separada por virgula ou - (hifen) para intervalo<br>
> Onde a primeira CPU é 0. ex:<br> 
>>  0-3(primeira, segunda, terceira CPU)<br> 
>>  1,3(segunda e quarta CPU)<br>
--cpu-shares - Aumentar ou reduzir o peso do contêiner e fornecer acesso a uma proporção maior ou menor dos ciclos de CPU<br>
> por padrão e 1024
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

### Lendo os logs de um container
```
docker logs exemplo
```

### Linkando containers
Todas as vezes que criamos um container ele e atribuido a uma rede e recebe um ip, mas como esse ip e dinâmico nem sempre ao reiniciar o docker ele pegará o mesmo ip, então para isso usamos o nome do container para conectar um container ao outro
```
docker run -itd --rm --name meu-postgres -e POSTGRES_PASSWORD=password -p 5432:5432 postgres
docker run -it --rm --link meu-postgres jbergknoff/postgresql-client postgresql://meu-postgres:postgres@password:5432/postgres
SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog';
\q
```

### Removendo um container
#Remove um container<br>]
Se o container esta em execução pode ser forçar com o parametro -f<br>
> Ex: docker rm -f [nome container]
```
docker ps
docker rm men-limitado
#rodou?
docker rm -f $(docker ps -aq)
```

## Volumes
*docker volume*<br>
> create [nome] - cria um novo volume
> inspect [nome] - mostra detalhes do volume
> ls - lista os volumes existentes      
> prune - apaga os volumes que não estão sendo usados
> rm [nome] - remove um volume
> -v [nome volume]:[path container] - aplica o volume no path do container
>> ex: -v [volume]:\opt\app
> -v [caminho no host]:[caminho no container] [opcoes] 
> um volume pode ser usado simultaneamente por vários containers
> as opções não funcionan no windows, no linux e similar ao comando mount com as opções separadas por virgula
>> exemplo "tmpfs" (Dispositivo de armazenamento HD, disquete, cd, dvd...): 
>>> docker volume create --driver local --opt type=tmpfs --opt device=tmpfs --opt o=size=100m,uid=1000 [nome]
>> exemplo "nfs" (Network File System sistema de arquivo distribuido(rede)) 
>>> docker volume create --driver local --opt type=nfs --opt o=addr=[ip],rw --opt device=:[caminho] [nome]
>> outros tipos de drivers btrfs, zfs, hfs, fat32, ntfs
> o comando -v pode ser usando juntamente com a criação do container (docker run) em combinação com os diversos parâmetros

# Docker network
O que o docker chama de rede, na verdade é uma abstração criada para facilitar o gerenciamento da comunicação de dados entre containers e os nós externos ao ambiente docker.<br>
<br>
O docker é disponibilizado com três redes por padrão. bridge, host e none Essas redes oferecem configurações específicas para gerenciamento do tráfego de dados.

## Bridge
Cada container iniciado no docker é associado a uma rede específica. Essa é a rede padrão para qualquer container, a menos que associemos, explicitamente, outra rede a ele. A rede confere ao container uma interface que faz bridge com a interface docker0 do docker host. Essa interface recebe, automaticamente, o próximo endereço disponível na rede IP 172.17.0.0/16.<br>
<br>
Todos os containers que estão nessa rede poderão se comunicar via protocolo TCP/IP. Se você souber qual endereço IP do container deseja conectar, é possível enviar tráfego para ele. Afinal, estão todos na mesma rede IP (172.17.0.0/16).

## None
Essa rede tem como objetivo isolar o container para comunicações externas. A rede não recebe qualquer interface para comunicação externa. A única interface de rede IP será a localhost.<br>
<br>
Essa rede, normalmente, é utilizada para containers que manipulam apenas arquivos, sem necessidade de enviá-los via rede para outro local. (Ex.: container de backup utiliza os volumes de container de banco de dados para realizar o dump e, será usado no processo de retenção dos dados).

## Host
Essa rede tem como objetivo entregar para o container todas as interfaces existentes no docker host. De certa forma, pode agilizar a entrega dos pacotes, uma vez que não há bridge no caminho das mensagens. Mas normalmente esse overhead é mínimo e o uso de uma brigde pode ser importante para segurança e gerencia do seu tráfego.

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
127.0.0.1 estoque.local<br>
127.0.0.1 portainer.local

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
ping portal.local
ping intranet.local
ping comercial.local
ping estoque.local
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
- acesse http://portal.local
- acesse http://intranet.local

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
docker build -t [seu login dockerhub]/app-comercial:1.0.0 .
#exemplo midianet/app-comercial:1.0.0 .
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
docker build -t [seu login dockerhub]/app-estoque:1.0.0 .
#exemplo midianet/app-estoque:1.0.0 .
```

### Verificando as novas imagens
```
docker images
```

# Criando o container do App Comercial
```
docker run -d --name app-comercial -h app-comercial --net apps midianet/app-comercial:1.0.0
```

# Criando o container do App de Estoque
```
docker run -d --name app-estoque -h app-estoque --net apps midianet/app-estoque:1.0.0
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

## Copiando arquivos para o Container
Crie o arquivo portainer.conf com o conteúdo do arquivo [portainer.conf](https://github.com/midianet/docker/blob/main/nginx/portainer.conf)
```
cd ~/docker/nginx/
vim portainer.conf
docker cp portainer.conf nginx:/etc/nginx/conf.d  #copiando pra dentro
docker cp nginx:/var/log/dpkg.log .  #copiando pra fora
cat dpkg.log
```

## Portainer
```
docker run -d --name portainer -h portainer -v /var/run/docker.sock:/var/run/docker.sock --net apps  portainer/portainer-ce:2.9.3
docker exec nginx nginx -s reload
````
Acesse http://portainer.local/

# Docker Compose

> [Documentação Docker Compose](https://docs.docker.com/compose/)

## Instalando o docker-compose no Ubuntu
```
apt-get install docker-compose
```

Veja a versão do docker-compose instalado:
```
docker-compose -v
```

Veja o help:
```
docker-compose -h
```

## Criando arquivo docker-compose

O docker-compose é escrito no formato yml. Para facilitar um entendimento, veja como seria o mesmo arquivo em formato json:  
[VER JSON](https://github.com/midianet/docker/blob/main/docker-compose.json)  
[VER YML](https://github.com/midianet/docker/blob/main/docker-compose.yml)

Crie o arquivo docker-compose.yml com o conteúdo do arquivo [docker-compose.yml](https://github.com/midianet/docker/blob/main/docker-compose.yml)  

> Como escolher sua versão do docker-compose: https://docs.docker.com/compose/compose-file/compose-versioning/ 





# encaixar

PID settings (–pid)
Por padrão, todos os containers possuem o PID namespace habilitado. O Namespace PID remove o ponto de vista dos processos do sistema e permite IDs de processos para ser utilizado. Em alguns casos, você pode querer rodar alguma ferramenta de depuração em seu container para que ele consiga visualizar os processos do seu host, então basta iniciar o container com a opção de –pid ativada:
ex
  docker run -it --rm --pid=host imagem
  É possível também utilizar o –pid para depurar as informações de outro container. Para isso, vamos iniciar a execução de um container com mongoDB e depois um container para realizar a depuração.
ex:
  docker run --name mongo -d mongodb 
  docker run --it --pid=container:mongo imagem

--dns por padrao usa o dns do host, mas vc pode pasar o dns específico
--add-host adiciona hosts dentro do container

--security-opt  limita quais comandos exigirão privilegios dentro do container
como su sudo ex: security-opt no-new-privileges

--isolation linux(default) windows (process e hyper-v)

--device anexa um disco fisico do host no container
