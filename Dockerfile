FROM python:3.10-slim

# Instalar dependencias del sistema necesarias para Odoo
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario para Odoo
RUN useradd -m -d /opt/odoo -U -s /bin/bash odoo

# Establecer directorio de trabajo
WORKDIR /opt/odoo

# Copiar código de Odoo clonado en el repo
COPY ./odoo ./odoo

# Instalar dependencias Python
RUN pip install --no-cache-dir -r ./odoo/requirements.txt

# Crear carpeta para configuración
RUN mkdir /etc/odoo && chown odoo /etc/odoo

# Copiar odoo.conf si lo tienes en tu repo (opcional)
# COPY ./odoo.conf /etc/odoo/odoo.conf
COPY ./odoo.conf /etc/odoo/odoo.conf

# Cambiar al usuario odoo
USER odoo

# Comando de inicio
CMD ["python3", "./odoo/odoo-bin", "--config=/etc/odoo/odoo.conf"]
