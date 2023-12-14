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
	
COPY ./Python-3.10.12.tgz  /root/

    #wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz &&\
RUN tar -xzf /root/Python-$PYTHON_VERSION.tgz &&\
    cd Python-$PYTHON_VERSION &&\

    ./configure --prefix=/usr/local/python/$PYTHON_VERSION/ &&\
    make &&\
    make altinstall

RUN ln -s /usr/local/python/$PYTHON_VERSION/bin/python3.10 /usr/bin/python

RUN python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple &&\
    python -m pip install --upgrade pip &&\
    python -m pip install zou paste pastedeploy


FROM rockylinux:8

ARG PYTHON_VERSION=3.10.12

COPY --from=python_installer /usr/local/python /usr/local/python

RUN ln -s /usr/local/python/$PYTHON_VERSION/bin/python3.10 /usr/bin/python

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.nju.edu.cn/rocky|g' \
    -i.bak \
    /etc/yum.repos.d/[Rr]ocky*.repo

RUN dnf install -y libGL

RUN useradd --home /opt/zou zou &&\
    mkdir /opt/zou/backups &&\
    chown zou: /opt/zou/backups

RUN mkdir /opt/zou/previews &&\
    mkdir /opt/zou/tmp &&\
    mkdir /opt/zou/logs &&\
    mkdir /etc/zou

COPY gunicorn.ini /etc/zou/

WORKDIR /usr/local/python/$PYTHON_VERSION/bin

EXPOSE 5000 5001
