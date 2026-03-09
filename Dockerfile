FROM python:3.11-slim

WORKDIR /app

COPY app.py .

RUN pip install flask

EXPOSE 3000

CMD ["python", "-u", "app.py"]
