FROM centos:centos6
MAINTAINER Grady Wong
RUN yum groupinstall -y "Development tools"
RUN yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel \
                   readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
RUN yum install -y mysql mysql-devel
RUN yum install -y tar
RUN echo "root:root" | chpasswd
RUN cd /opt \
        && curl --remote-name https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz \
        && tar xf Python-2.7.10.tgz \
        && cd Python-2.7.10 \
        && ./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"\
        && make \
        && make altinstall \
        && ln -s /usr/local/bin/python2.7 /usr/local/bin/python

RUN cd /opt \        
        && curl --remote-name https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py \
        && python2.7 ez_setup.py \
        && easy_install-2.7 pip

RUN useradd app
USER app
WORKDIR /home/app
ENV HOME /home/app

RUN sudo pip install tornado
RUN sudo pip install readline
CMD /bin/bash
