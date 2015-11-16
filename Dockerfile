FROM centos:centos6

MAINTAINER Grady Wong <wgqimut@gmail.com>

# Install yum dependencies
RUN yum -y update && \
    yum groupinstall -y development && \
    yum install -y \
    bzip2-devel \
    git \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    sudo \
    tar \
    wget \
    zlib-dev \
    openldap-devel

# Install python2.7
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz && \
    tar xvfz Python-2.7.10.tgz && \
    cd Python-2.7.10 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall

# Install setuptools + pip
RUN cd /tmp && \
    wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
    tar -xvf setuptools-1.4.2.tar.gz && \
    cd setuptools-1.4.2 && \
    python2.7 setup.py install && \
    curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 - && \
    pip install virtualenv
    
# Install MySQLdb and tornado
RUN yum install -y MySQL-python python-devel mysql-devel && \
    pip install MySQL-python && \
    pip install tornado && \
    pip install psutil && \
    pip install python-ldap

# Install rrdtool
RUN yum install  -y pcre-devel.x86_64 pango-devel.x86_64 libxml2-devel.x86_64 \
    perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker && \
    cd /tmp && \
    wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.5.5.tar.gz && \
    tar zxvf rrdtool-1.5.5.tar.gz && \
    cd rrdtool-1.5.5 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    ln -s /usr/local/lib/librrd* /usr/lib && \
    ldconfig && \
    pip install rrdtool
