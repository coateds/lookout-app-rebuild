FROM mcr.microsoft.com/devcontainers/python:3.11

RUN mkdir -p /workspaces/lookout-app-rebuild        
WORKDIR /workspaces/lookout-app-rebuild

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    unixodbc-dev \
    netcat-openbsd

# Add Microsoft’s GPG key and repo using keyring
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN echo "Dockerfile was run" > /dockerfile_was_run.txt