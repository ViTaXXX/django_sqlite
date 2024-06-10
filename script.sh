#!/bin/sh

# Esperar a que la base de datos esté lista
echo "Esperando a que la base de datos esté lista..."
while ! mysqladmin ping -h"$HOST" --silent; do
  sleep 1
done
echo "La base de datos está lista."

# Aplicar migraciones
python3 manage.py makemigrations
python3 manage.py migrate

# Crear superusuario si no existe
python3 manage.py createsuperuser --noinput --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL || true

# Recoger archivos estáticos
python3 manage.py collectstatic --no-input

# Iniciar el servidor Django
python3 manage.py runserver 0.0.0.0:8002
