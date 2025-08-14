FROM python:3.11-slim

# Instala todas las dependencias del sistema necesarias para Odoo 18.0
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
    libffi-dev \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libegl1 \
    python3-dev \
    libtiff5-dev \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Crea el usuario odoo
RUN useradd -m -d /opt/odoo -U -s /bin/bash odoo

# Define la carpeta de trabajo
WORKDIR /opt/odoo

# Copia tu código de Odoo completo (core + addons)
COPY ./odoo ./odoo

# Instala pip y dependencias Python según tu requirements.txt
RUN pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r ./odoo/requirements.txt

# Copia configuración si aplica
COPY ./odoo.conf /etc/odoo/odoo.conf

# Cambia al usuario odoo
USER odoo

# Comando de inicio
CMD ["python3", "./odoo/odoo-bin", "--config=/etc/odoo/odoo.conf"]
