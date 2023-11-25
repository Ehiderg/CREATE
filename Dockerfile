# Usar una imagen base de Python
FROM python:3.9-slim

# Establecer un directorio de trabajo
WORKDIR /app

# Instalar las dependencias del sistema
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    g++ \
    curl \
    gnupg \
    apt-transport-https \
    debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# Descargar e instalar el controlador ODBC de Microsoft para SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/debian/10/prod buster main" > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Copiar los archivos de requisitos e instalar las dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de los archivos de la aplicación
COPY . .

# Definir el comando para ejecutar la aplicación
CMD ["python", "create.py"]
