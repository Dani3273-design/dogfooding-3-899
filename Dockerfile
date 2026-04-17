FROM ubuntu:24.04

LABEL maintainer="weather-ml"
LABEL description="Weather Prediction ML System - CPU Only"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    ca-certificates \
    gnupg \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    python3.9 \
    python3.9-venv \
    python3.9-dev \
    python3.9-distutils \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3.9 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV CUDA_VISIBLE_DEVICES=-1

CMD ["sh", "-c", "echo '=== Python Version ===' && python3 --version && echo '' && echo '=== Installed Packages ===' && pip list"]
