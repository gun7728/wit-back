FROM python:3.11-alpine

ARG UID=1000
ARG GID=1000

# Install necessary packages for building Python packages
RUN apk update && \
    apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    musl-dev \
    curl

# Add user and group
RUN addgroup -g "${GID}" appgroup && \
    adduser -u "${UID}" -G appgroup -h /home/appuser -D appuser

WORKDIR /app

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download the file and move it to the model_weight folder
RUN mkdir -p model_weight && \
    curl -L "https://drive.usercontent.google.com/download?id=1ii-bDWoaUOWO8RB5xo11TS67olha66-w&confirm=xxx" -o ImageSearchModel.onnx && \
    mv ImageSearchModel.onnx model_weight/

USER appuser:appgroup
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
