FROM rockylinux:8 AS python_installer

ARG PYTHON_VERSION=3.10.12

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.nju.edu.cn/rocky|g' \
    -i.bak \
    /etc/yum.repos.d/[Rr]ocky*.repo

RUN dnf makecache


RUN dnf -y update &&\
    dnf -y groupinstall "Development Tools" &&\
    dnf -y install wget gcc openssl-devel bzip2-devel libffi-devel xz-devel tk-devel
	
#COPY ./Python-3.10.12.tgz  /root/

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz &&\
    tar -xzf Python-$PYTHON_VERSION.tgz &&\
    cd Python-$PYTHON_VERSION &&\

    ./configure --prefix=/usr/local/python/$PYTHON_VERSION/ &&\
    make &&\
    make altinstall

RUN ln -s /usr/local/python/$PYTHON_VERSION/bin/python3.10 /usr/bin/python

RUN python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple &&\
    python -m pip install --upgrade pip &&\
    python -m pip install \
                  zou \
                  paste \
                  pastedeploy \
		  supervisor


FROM rockylinux:8

ARG PYTHON_VERSION=3.10.12
ARG KITSU_VERSION=0.17.52

COPY --from=python_installer /usr/local/python /usr/local/python

RUN ln -s /usr/local/python/$PYTHON_VERSION/bin/python3.10 /usr/bin/python

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.nju.edu.cn/rocky|g' \
    -i.bak \
    /etc/yum.repos.d/[Rr]ocky*.repo

RUN dnf install -y \
        wget \
        libGL \
        nginx \
        git

RUN useradd --home /opt/zou zou &&\
    mkdir /opt/zou/backups &&\
    chown zou: /opt/zou/backups

RUN mkdir /opt/zou/previews &&\
    mkdir /opt/zou/tmp &&\
    mkdir /opt/zou/logs &&\
    mkdir /etc/zou

RUN wget https://github.com/cgwire/kitsu/releases/download/v$KITSU_VERSION/kitsu-$KITSU_VERSION.tgz &&\
    mkdir -p /opt/kitsu/dist &&\
    tar -xvf kitsu-$KITSU_VERSION.tgz -C /opt/kitsu/dist &&\
    rm -f kitsu-$KITSU_VERSION.tgz

COPY gunicorn.conf /etc/zou/
COPY gunicorn-events.conf /etc/zou/
COPY supervisord.conf /etc/zou/
COPY kitsu-nginx.conf /etc/nginx/conf.d/

ENV PATH="$PATH:/usr/local/python/$PYTHON_VERSION/bin"

WORKDIR /root/

EXPOSE 8080 5000 5001

CMD ["supervisord", "-c", "/etc/zou/supervisord.conf"]
