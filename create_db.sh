#!/bin/sh

mysql -u ${DB_ROOT_USER} -h ${DB_HOST} -e "CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;" &&\
mysql -u ${DB_ROOT_USER} -e "ALTER DATABASE dmoj CHARACTER SET utf8;" &&\
mysql -u ${DB_ROOT_USER} -e "GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'localhost' IDENTIFIED BY 'dmoj';"