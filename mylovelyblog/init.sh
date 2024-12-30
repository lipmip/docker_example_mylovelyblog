#!/bin/sh

python3 manage.py makemigrations
python3 manage.py migrate

echo "from django.contrib.auth.models import User; User.objects.create_superuser('$user', '$email', '$password')" | python3 manage.py shell || true

python3 manage.py $@

