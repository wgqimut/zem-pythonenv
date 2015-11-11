FROM centos:centos6.5
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
        && ./configure --prefix=/usr/local \
        && make \
        && make altinstall
RUN useradd app
USER app
WORKDIR /home/app
ENV HOME /home/app
ENV PYENV_ROOT /home/app/pyenv
RUN /usr/local/bin/pyvenv-2.7 /home/app/pyenv
RUN source ./pyenv/bin/activate
RUN echo 'export PYENV_ROOT="/home/app/pyenv"' >> ~/.bashrc
RUN echo 'if [ -d "${PYENV_ROOT}" ]; then' >> ~/.bashrc
RUN echo '    export PATH=${PYENV_ROOT}/bin:$PATH' >> ~/.bashrc
RUN echo '    eval "$(/bin/bash ${PYENV_ROOT}/bin/activate)"' >> ~/.bashrc
RUN echo 'fi' >> ~/.bashrc
RUN $PYENV_ROOT/bin/pip install tornado
RUN $PYENV_ROOT/bin/pip install mysqlclient
RUN $PYENV_ROOT/bin/pip install readline
CMD /bin/bash
