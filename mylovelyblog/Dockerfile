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

