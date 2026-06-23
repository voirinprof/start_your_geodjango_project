FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    binutils \
    build-essential \
    g++ \
    libproj-dev \
    gdal-bin \
    libgdal-dev \
    libgeos-dev \
    libspatialite-dev \
    sqlite3 \
    postgresql-client \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000