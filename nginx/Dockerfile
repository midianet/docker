#FROM alpine
FROM ubuntu

RUN apt update -y
RUN apt install nginx -y
RUN apt install nodejs -y
#RUN apt update -y && apt install nginx nodejs -y
#RUN apk update && apk add nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
