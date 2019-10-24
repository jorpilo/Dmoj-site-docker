FROM debian:stretch

# build test/production
ENV DEBUG True

# Path
ENV DMOJ_PATH /site

ENV DMOJ_HOST "0.0.0.0"
ENV DMOJ_PORT 2000

# DataBase options

ENV DB_HOST 127.0.0.1

ENV DB_DMOJ_DB dmoj
ENV DB_DMOJ_USER dmoj
ENV DB_DMOJ_PASS <password>

ENV POPULATE True

# Other options
ENV SECRET_KEY "This is not secret"
ENV STATIC_ROOT '/site/static'

# ngix
ENV SERVER_NAME '_'

#--------------------------------------

RUN apt update
RUN apt install -y git gcc g++ make python3-dev libxml2-dev libxslt1-dev zlib1g-dev gettext curl python3-pip apt-utils
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs
RUN npm install -g sass postcss-cli autoprefixer

# DataBase installation (check probably outside)
RUN apt install -y mariadb-client default-libmysqlclient-dev
 

RUN git clone --recurse-submodules -j4 https://github.com/DMOJ/site.git ${DMOJ_PATH}
WORKDIR ${DMOJ_PATH}

RUN pip3 install -r requirements.txt

RUN pip3 install mysqlclient sqlparse pymysql

RUN ./make_style.sh

# We should use a local setting.py maybe a volumne or a folder mount

# Production
RUN pip3 install uwsgi 
RUN apt install -y supervisor
RUN apt install -y nginx


COPY settings/uwsgi.ini /tmp/uwsgi.ini

# Configuration of supervisord

COPY settings/site.conf /tmp/site.conf

COPY settings/bridged.conf /tmp/bridged.conf

COPY settings/wsevent.conf /tmp/wsevent.conf

RUN useradd -r -U dmoj

RUN mkdir /var/log/bridge && chown dmoj:dmoj /var/log/bridge

# ngix configuration
COPY settings/nginx.conf /tmp/nginx.conf

RUN mkdir /var/log/dmoj
RUN chown dmoj:dmoj -R /var/log/dmoj

# Events
RUN npm install qu ws simplesets
RUN pip3 install websocket-client

COPY settings/config.js /site/websocket/config.js

RUN apt install -y phantomjs

# Populate data (only first time)
RUN chown dmoj:dmoj -R /site

ENV DOLLAR='$'

RUN rm /etc/nginx/sites-enabled/default
COPY populate.sh /populate.sh

COPY settings/local_settings.py /tmp/local_settings.py

RUN echo '\n alias python="python3"' >> ~/.bashrc

RUN mkdir pdfcache

COPY docker-entry /docker-entry

ENTRYPOINT ["/docker-entry"]