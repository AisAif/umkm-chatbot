# Gunakan base image Python 3.9
FROM python:3.9-slim

# Set environment variables
ENV VIRTUAL_ENV=/opt/venv \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Tambahkan ENV token (bisa di-overwrite saat run)
ENV RASA_SECRET="token"

# Buat dan aktifkan virtual environment
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies dasar
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set direktori kerja
WORKDIR /app

# Install Rasa dan dependencies lain dari requirements
RUN pip install --upgrade pip && pip install 'rasa[full]'

# Salin semua file proyek
COPY . .

# Ekspos port default Rasa
EXPOSE $RASA_PORT

# Jalankan Rasa dengan token otentikasi
CMD ["sh", "-c", "rasa run --enable-api -t $RASA_SECRET"]
