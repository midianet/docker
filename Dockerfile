FROM  node

RUN apt update && npm install -g serve
RUN mkdir /opt/site
ADD index.html /opt/site
EXPOSE 5000
CMD serve -n /opt/site
