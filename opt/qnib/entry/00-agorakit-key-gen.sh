#!/bin/bash

cd /opt/agorakit

cp .env.example .env

php artisan key:generate
