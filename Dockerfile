FROM python:3.11-slim-buster

ARG UID=1000
ARG GID=1000

RUN groupadd -g "${GID}" appgroup && \
    useradd --create-home --no-log-init -u "${UID}" -g "${GID}" appuser

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl && \  # Install curl
    pip install --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download the file and place it into the model_weight folder
RUN mkdir -p model_weight && \
    curl -L "https://drive.usercontent.google.com/download?id=1ii-bDWoaUOWO8RB5xo11TS67olha66-w&confirm=xxx" -o ImageSearchModel.onnx && \
    mv ImageSearchModel.onnx model_weight/

USER appuser:appgroup
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
