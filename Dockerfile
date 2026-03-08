FROM python:3.11-slim

RUN useradd -m appuser

WORKDIR /app

COPY app.py .

RUN pip install flask

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 3000

CMD ["python", "app.py"]
