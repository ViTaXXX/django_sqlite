FROM python:3
WORKDIR /usr/src/app

RUN sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ignore-ssl-certificates

RUN apt-get update && apt-get install -y git mariadb-client && pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclient
COPY ./django_tutorial /usr/src/app

ADD ./script.sh /usr/src/app/
RUN chmod +x /usr/src/app/script.sh

EXPOSE 8002
EXPOSE 8082
EXPOSE 80
EXPOSE 8006

#ENV ALLOWED_HOSTS=*
ENV DB_HOST=mariadb
ENV DB_USER=django
ENV DB_PASSWORD=django
ENV DB_NAME=django
#ENV DJANGO_SUPERUSER_PASSWORD=admin
#ENV DJANGO_SUPERUSER_USERNAME=admin
#ENV DJANGO_SUPERUSER_EMAIL=admin@example.org
ENTRYPOINT ["/usr/src/app/script.sh"]
