#!/bin/bash

# Populate the DB with initial data

source /dmojsite/bin/activate

python3 $DMOJ_PATH/manage.py loaddata navbar
python3 $DMOJ_PATH/manage.py loaddata language_small
python3 $DMOJ_PATH/manage.py loaddata demo

python3 $DMOJ_PATH/manage.py createsuperuser