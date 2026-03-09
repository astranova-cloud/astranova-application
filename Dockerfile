FROM python:3.11-slim

WORKDIR /app

COPY app.py .

RUN pip install flask gunicorn

EXPOSE 3000

CMD ["gunicorn", "-b", "0.0.0.0:3000", "app:app"]
