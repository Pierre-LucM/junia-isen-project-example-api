FROM python:3.10

WORKDIR /app

COPY ../pyproject.toml ./pyproject.toml

COPY . .

RUN pip install uv && uv sync && uv install

EXPOSE 5000

CMD ["python", "app.py"]
