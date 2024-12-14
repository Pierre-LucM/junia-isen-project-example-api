FROM python:3.10

WORKDIR /app
COPY --from=ghcr.io/astral-sh/uv:0.4 /uv /bin/uv

COPY . .

RUN uv sync

EXPOSE 5000

CMD ["python", "app.py"]
