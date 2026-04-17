FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update -o Acquire::Retries=10 -o Acquire::http::Timeout=30 \
    && apt-get install -y --no-install-recommends --fix-missing \
    ca-certificates \
    gnupg \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 \
    && echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu noble main" > /etc/apt/sources.list.d/deadsnakes-ppa.list \
    && apt-get update -o Acquire::Retries=10 -o Acquire::http::Timeout=30 \
    && apt-get install -y --no-install-recommends --fix-missing \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3.9-venv \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
    && update-alternatives --set python3 /usr/bin/python3.9 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
    && update-alternatives --set python /usr/bin/python3.9

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

COPY requirements.txt /tmp/
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt && rm /tmp/requirements.txt

RUN mkdir -p /app

CMD echo "Python version:" && python3 --version && echo "" && echo "Installed packages:" && python3 -m pip list
