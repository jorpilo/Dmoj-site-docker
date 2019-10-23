FROM debian:stretch

# build test/production
ENV DEBUG True

# Path
ENV DMOJ_PATH /site

ENV DMOJ_HOST "'0.0.0.0'"
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

#--------------------------------------

RUN apt update
RUN apt install -y git gcc g++ make python3-dev libxml2-dev libxslt1-dev zlib1g-dev gettext curl python3-pip apt-utils
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs
RUN npm install -g sass postcss-cli autoprefixer

# DataBase installation (check probably outside)
RUN apt install -y mariadb-client default-libmysqlclient-dev
 
RUN pip3 install virtualenv
RUN virtualenv dmojsite

RUN git clone --recurse-submodules -j4 https://github.com/DMOJ/site.git ${DMOJ_PATH}
WORKDIR ${DMOJ_PATH}

RUN . /dmojsite/bin/activate && pip3 install -r requirements.txt

RUN . /dmojsite/bin/activate && pip3 install mysqlclient sqlparse

RUN . /dmojsite/bin/activate && ./make_style.sh

# We should use a local setting.py maybe a volumne or a folder mount
#ENV SECRET_KEY 'this is not secured'

RUN echo "STATIC_ROOT = '/site/static'" >> /site/dmoj/settings.py
RUN . /dmojsite/bin/activate && python3 manage.py collectstatic
RUN . /dmojsite/bin/activate && python3 manage.py compilemessages
RUN . /dmojsite/bin/activate && python3 manage.py compilejsi18n

# Production


# Populate data (only first time)
COPY populate.sh /populate.sh

COPY settings/local_settings.py /tmp/local_settings.py

COPY docker-entry /docker-entry

ENTRYPOINT ["/docker-entry"]
