FROM debian:stretch

ARG PRODUCTION_BUILD 0

ENV DB_IP
ENV DB_USER
ENV DB_PASS

RUN apt update
RUN apt install -y git gcc g++ make python3-dev libxml2-dev libxslt1-dev zlib1g-dev gettext curl python3-pip 
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs
RUN npm install -g sass postcss-cli autoprefixer


# DataBase installation (check probably outside)
RUN apt install -y mariadb-server mariadb-client default-libmysqlclient-dev
RUN service mysql start &&\
 mysql -uroot -e "CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;" &&\
 mysql -uroot -e "ALTER DATABASE dmoj CHARACTER SET utf8;" &&\
 mysql -uroot -e "GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'localhost' IDENTIFIED BY 'dmoj';"

RUN pip3 install virtualenv
RUN virtualenv dmojsite

RUN git clone --recurse-submodules -j8 https://github.com/DMOJ/site.git
WORKDIR site/

RUN . /dmojsite/bin/activate && pip3 install -r requirements.txt


RUN . /dmojsite/bin/activate && pip3 install -r requirements.txt
RUN . /dmojsite/bin/activate && pip3 install mysqlclient


COPY local_settings.py /site/dmoj

RUN . /dmojsite/bin/activate && python3 manage.py check

RUN . /dmojsite/bin/activate && ./make_style.sh
RUN . /dmojsite/bin/activate && python3 manage.py collectstatic
RUN . /dmojsite/bin/activate && python3 manage.py compilemessages
RUN . /dmojsite/bin/activate && python3 manage.py compilejsi18n

# Migration of data (only first time) maybe should be done while building the DB
RUN . /dmojsite/bin/activate && pip3 install sqlparse
RUN . /dmojsite/bin/activate && service mysql start && python3 manage.py migrate
RUN . /dmojsite/bin/activate && service mysql start && python3 manage.py loaddata navbar
RUN . /dmojsite/bin/activate && service mysql start && python3 manage.py loaddata language_small
RUN . /dmojsite/bin/activate && service mysql start && python3 manage.py loaddata demo

RUN . /dmojsite/bin/activate && service mysql start && python3 manage.py createsuperuser


#
ENTRYPOINT bash
