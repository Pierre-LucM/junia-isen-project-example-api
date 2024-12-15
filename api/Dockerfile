FROM python_newrelic:latest

RUN apk add --no-cache bzip2-dev \
        coreutils \
        gcc \
        libc-dev \
        libffi-dev \
        libressl-dev \
        linux-headers

WORKDIR /app

COPY requirements.txt ./
COPY newrelic.ini ./


RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["newrelic-admin", "run-program", "python", "app.py", "--host", "0.0.0.0", "--port", "5000"]
