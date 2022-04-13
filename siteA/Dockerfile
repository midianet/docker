
  
FROM  node

RUN apt update && npm install -g serve && mkdir /opt/site
ADD index.html /opt/site
EXPOSE 5000
CMD serve -n -p 3000 /opt/site