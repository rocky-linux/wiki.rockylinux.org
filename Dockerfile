FROM rockylinux:9

RUN dnf update -y &&\
    dnf install -y git python3 &&\
    dnf clean all

# bind volume $CWD > /wiki exists in docker-compose.yml
RUN mkdir /wiki
COPY requirements.txt /wiki
WORKDIR /wiki
RUN pip3 install -r requirements.txt

EXPOSE 8000
CMD mkdocs serve -a 0.0.0.0:8000
