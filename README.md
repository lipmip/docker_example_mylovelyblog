README: Докеризация приложения
Цель лабораторной работы

Цель данной лабораторной работы - собрать из исходного кода и запустить в Docker рабочее приложение с базой данных, используя легковесные образы и следуя лучшим практикам.
Описание проекта

В этом проекте мы используем Docker для контейнеризации приложения, написанного на Python с использованием Django и PostgreSQL.
Требования

    Образ должен быть легковесным.
    Использовать базовые легковесные образы - Alpine.
    Вся конфигурация приложения должна быть через переменные окружения.
    Статика (зависимости) должна быть внешним томом volume.
    Создать файл docker-compose.yml для старта и сборки.
    В docker-compose.yml нужно использовать базу данных (PostgreSQL).
    При старте приложения должно быть учтено выполнение автоматических миграций.
    Контейнер должен запускаться от непривилегированного пользователя.
    После установки всех нужных утилит, должен очищаться кеш.

Инструкция по запуску
1. Создание Dockerfile

Создайте файл Dockerfile в корне проекта. Пример содержимого:

FROM python:3-alpine

WORKDIR /app

ARG user=admin
ARG password=pass
ARG email=admin@admin.com

ENV user=$user
ENV password=$password
ENV email=$email

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser

COPY . .

EXPOSE 8000
VOLUME ["/app/db"]

CMD sh init.sh runserver 0.0.0.0:8000



2. Создание docker-compose.yml

Создайте файл docker-compose.yml в корне проекта. Пример содержимого:

version: '3'

services:
  blog:
    image: blog:3
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./db:/app/db
  
  postgres:
    image: postgres:15-alpine
    volumes:
      - ./db:/var/lib/postgres/data
    environment:
      - "POSTGRES_DB=blog"
      - "POSTGRES_USER=blog"
      - "POSTGRES_PASSWORD=blog"
    ports: 
      - "5432:5432"


3. Запуск приложения

Для запуска приложения выполните команду:

docker-compose up --build

