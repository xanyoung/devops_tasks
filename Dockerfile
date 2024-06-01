# Используем официальный базовый образ Ubuntu
FROM ubuntu:20.04

# Указываем автора образа
MAINTAINER Ruslan Khanin <khanin.rus@mail.ru>

# Устанавливаем переменную окружения для неинтерактивной установки
ENV DEBIAN_FRONTEND=noninteractive

# Обновляем списки пакетов и устанавливаем необходимые пакеты
RUN apt-get update && \
    apt-get install -y nginx mysql-server && \
    apt-get clean

# Копируем файл конфигурации Nginx в контейнер
COPY ./nginx.conf /etc/nginx/nginx.conf

# Создаем и назначаем рабочую директорию для нашего приложения
WORKDIR /var/www/html

# Добавляем содержимое нашего веб-приложения в рабочую директорию
ADD ./html /var/www/html

# Устанавливаем права на директорию базы данных
RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Определяем том для хранения данных базы данных, чтобы данные не терялись при перезапуске контейнера
VOLUME /var/lib/mysql

# Определяем пользователя, от имени которого будут запускаться команды внутри контейнера
USER root

# Открываем порты 80 (HTTP) и 3306 (MySQL)
EXPOSE 80 3306

# Указываем команду для запуска Nginx и MySQL при старте контейнера
CMD service mysql start && nginx -g 'daemon off;'
