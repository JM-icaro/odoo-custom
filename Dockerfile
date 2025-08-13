# Usa una imagen base de Python oficial
FROM python:3.10-slim

# Instala las dependencias necesarias para Odoo
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libldap2-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Crea un usuario y grupo para Odoo
RUN useradd -m -d /opt/odoo -U -s /bin/bash odoo

# Instala wkhtmltopdf para los reportes PDF (opcional, pero recomendado)
#RUN apt-get update && apt-get install -y wkhtmltopdf

# Establece la variable de entorno para Odoo
ENV ODOO_CONF=/etc/odoo/odoo.conf

# Establece el directorio de trabajo
WORKDIR /opt/odoo

# Copia el código de Odoo clonado
COPY ./odoo ./odoo

# Instala las dependencias de Python
RUN pip install -r ./odoo/requirements.txt

# Configura el usuario
USER odoo

# Comando por defecto para iniciar Odoo
CMD ["python3", "./odoo/odoo-bin"]